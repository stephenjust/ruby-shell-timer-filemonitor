require 'test/unit/assertions'

module Contracts
  module FileWatch
    include Test::Unit::Assertions

    def pre_listenForCreation(files, &block)
      assert_not_nil files "Files to listen for must be provided!"
      assert_not_nil block "A listener must be provided!"
      assert files.responds_to?(:each), "files must support the 'each' operation"
      files.each do |val|
        assert val.responds_to?(:to_s), "file must be convertible to a string!"
        assert !File.file?(val.to_s), "file cannot already exist if we are listening for its creation!"
      end
    end
    def post_listenForCreation
      assert @creation_listeners.responds_to(:length)
      assert (@creation_listeners.length > 0), "listenForCreation must have added some listeners!"
    end
    
    def pre_listenForAlterations(files, &block)
      assert_not_nil files "Files to listen for must be provided!"
      assert_not_nil block "A listener must be provided!"
      assert files.responds_to?(:each),  "files must support the 'each' operation"
      files.each do |val|
        assert val.responds_to?(:to_s), "file must be convertible to a string!"
        assert File.file?(val.to_s), "file must already exist if we are listening for its alteration!"
      end
    end
    def post_listenForAlterations
      assert @alterations_listeners.responds_to(:length)
      assert (@alterations_listeners.length > 0), "listenForAlterations must have added some listeners!"
    end
    
    def pre_listenForDelete(files, &block)
      assert_not_nil files "Files to listen for must be provided!"
      assert_not_nil block "A listener must be provided!"
      assert files.responds_to?(:each), "files must support the 'each' operation"
      files.each do |val|
        assert val.responds_to?(:to_s), "file must be convertible to a string!"
        assert File.file?(val.to_s), "file must already exist if we are listening for its deletion!"
      end
    end
    def post_listenForDelete
      assert @deletion_listeners.responds_to(:length)
      assert (@deletion_listeners.length > 0), "listenForDelete must have added some listeners!"
    end
    
    def class_invariant
      assert self.responds_to?(:listenForCreation), "FileWatcher must support listenForCreation"
      assert self.responds_to?(:listenForAlter), "FileWatcher must support listenForAlter"
      assert self.responds_to?(:listenForDelete), "FileWatcher must support listenForDelete"
    end

  end

end
