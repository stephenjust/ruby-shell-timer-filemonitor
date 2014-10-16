require 'test/unit/assertions'

module Contracts
  module Timer
    include Test::Unit::Assertions

    def pre_wait_then_execute(time, &block)
      assert_not_nil time, "time cannot be nil"
      assert (time > 0), "time cannot be less than or equal to zero"
      assert_not_nil block, "action cannot be nil"
    end
    
    def class_invariant
      assert self.responds_to?(:wait_then_execute), "timer must support wait_then_execute"
    end

  end

end
