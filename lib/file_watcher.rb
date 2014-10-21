require 'listen'

require_relative './contracts/filewatch_contract'

class FileWatcher
  def initialize()
    @creation_listeners = []
    @alterations_listeners = []
    @deletion_listeners = []
  end

  def listen_for_creation(files, duration, &block)
    selector = Proc.new do |modified, added, removed|
      added
    end
    listen_impl(files, @creation_listeners, duration, selector, &block)
  end

  def listen_for_alteration(files, duration, &block)
    selector = Proc.new do |modified, added, removed|
      modified
    end
    listen_impl(files, @alterations_listeners, duration, selector, &block)
  end

  def listen_for_delete(files, duration, &block)
    selector = Proc.new do |modified, added, removed|
      removed
    end
    listen_impl(files, @deletion_listeners, duration, selector, &block)
  end

  private
  def listen_impl(files, list, duration, selector, &block)
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
          sleep(duration)
          block.call(val)
        end
      end
    end
    list << listener
    listener.start
  end
end