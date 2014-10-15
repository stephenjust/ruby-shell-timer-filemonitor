require 'test/unit/assertions'

module Contracts
  module FileWatch
    include Test::Unit::Assertions

    def pre_listenForCreation
    
    end
    def post_listenForCreation
    
    end
    
    def pre_listenForAlter
    
    end
    def post_listenForAlter
    
    end
    
    def pre_listenForDelete
    
    end
    def post_listenForDelete
    
    end
    
    
    def class_invariant
      
      assert self.responds_to?(:listenForCreation)
      assert self.responds_to?(:listenForAlter)
      assert self.responds_to?(:listenForDelete)
      
    end

  end

end
