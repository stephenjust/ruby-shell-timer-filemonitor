require 'listen'

require_relative './contracts/filewatch_contract'

class FileWatcher
  include Contracts::FileWatch

  def initialize()
    @creation_listeners = []
    @alteration_listeners = []
    @deletion_listeners = []
    class_invariant
  end

  def listen_for_creation(files, duration, runOnce = true, &block)
    class_invariant
    pre_listen_for_creation(files, &block)

    selector = Proc.new do |modified, added, removed|
      added
    end
    listen_impl(files, @creation_listeners, duration, selector, runOnce, &block)

    post_listen_for_creation
    class_invariant
  end

  def listen_for_alteration(files, duration, runOnce = true, &block)
    class_invariant
    pre_listen_for_alteration(files, &block)

    selector = Proc.new do |modified, added, removed|
      modified
    end
    listen_impl(files, @alteration_listeners, duration, selector, runOnce, &block)

    post_listen_for_alteration
    class_invariant
  end

  def listen_for_delete(files, duration, runOnce = true, &block)
    class_invariant
    pre_listen_for_delete(files, &block)

    selector = Proc.new do |modified, added, removed|
      removed
    end
    listen_impl(files, @deletion_listeners, duration, selector, runOnce, &block)

    post_listen_for_delete
    class_invariant
  end

  private
  def listen_impl(files, list, duration, selector, runOnce, &block)
    # convert files to absolute paths
    files.map! do |val|
      File.absolute_path(val)
    end

    # convert each path to a directory
    dirs = files.map do |val|
      val = File.dirname(val) unless File.directory?(val)
      val
    end
    listener = Listen.to(dirs) do |modified, added, removed|
      set = selector.call(modified, added, removed)
      (files & set).each do |val|
        # putting in a separate thread so the listener doesn't block
        Thread.new do ||
          begin
            block.call(val)
            listener.stop if runOnce
          rescue Exception => ex
            puts "Error in listener : #{ex}"
          end
        end
      end
    end
    Thread.new do ||
      sleep(duration)
      listener.stop
    end
    list << listener
    listener.start
  end
end
