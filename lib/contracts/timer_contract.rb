require 'test/unit/assertions'

module Contracts
  module Timer
    include Test::Unit::Assertions

    def pre_wait_then_execute(time, &block)
      assert time > 0
      assert_not_nil block
    end
    
    def class_invariant
      assert self.responds_to?(:wait_then_execute)
    end

  end

end
