require 'test/unit/assertions'

module Contracts
  module FileWatch
    include Test::Unit::Assertions

    def pre_listen_for_creation(files, &block)
      assert_not_nil files "Files to listen for must be provided!"
      assert_not_nil block "A listener must be provided!"
      assert files.responds_to?(:each), "files must support the 'each' operation"
      files.each do |val|
        assert val.responds_to?(:to_s), "file must be convertible to a string!"
        assert !File.file?(val.to_s), "file cannot already exist if we are listening for its creation!"
      end
    end
    def post_listen_for_creation
      assert @creation_listeners.responds_to(:length)
      assert (@creation_listeners.length > 0), "listen_for_creation must have added some listeners!"
    end
    
    def pre_listen_for_alteration(files, &block)
      assert_not_nil files "Files to listen for must be provided!"
      assert_not_nil block "A listener must be provided!"
      assert files.responds_to?(:each),  "files must support the 'each' operation"
      files.each do |val|
        assert val.responds_to?(:to_s), "file must be convertible to a string!"
        assert File.file?(val.to_s), "file must already exist if we are listening for its alteration!"
      end
    end
    def post_listen_for_alteration
      assert @alterations_listeners.responds_to(:length)
      assert (@alterations_listeners.length > 0), "listen_for_alteration must have added some listeners!"
    end
    
    def pre_listen_for_delete(files, &block)
      assert_not_nil files "Files to listen for must be provided!"
      assert_not_nil block "A listener must be provided!"
      assert files.responds_to?(:each), "files must support the 'each' operation"
      files.each do |val|
        assert val.responds_to?(:to_s), "file must be convertible to a string!"
        assert File.file?(val.to_s), "file must already exist if we are listening for its deletion!"
      end
    end
    def post_listen_for_delete
      assert @deletion_listeners.responds_to(:length)
      assert (@deletion_listeners.length > 0), "listen_for_delete must have added some listeners!"
    end
    
    def class_invariant
      assert self.responds_to?(:listen_for_creation), "FileWatcher must support listen_for_creation"
      assert self.responds_to?(:listen_for_alteration), "FileWatcher must support listen_for_alteration"
      assert self.responds_to?(:listen_for_delete), "FileWatcher must support listen_for_delete"
    end

  end

end
