require 'test/unit/assertions'

module Contracts
  module Shell
    include Test::Unit::Assertions

    def pre_execute_cmd(cmd)
      assert_not_nil cmd
    end
    
    def pre_is_internal_cmd?
      assert_not_nil @internal_cmds
    end
    
    def pre_run(cmdInput)
      assert_not_nil cmdInput
      assert self.is_valid_cmd(cmdInput?)
    end
    
    def class_invariant
      assert self.responds_to?(:execute_cmd), "Shell must support execute_cmd"
      assert self.responds_to?(:is_internal_cmd?), "Shell must support is_internal_cmd?"
      assert self.responds_to?(:run) , "Shell must support run"
      assert self.responds_to?(:is_valid_cmd?), "Shell must support is_valid_cmd?"
      assert(File.directory?(self.pwd), "Current path #{self.pwd} must be a directory.")
    end

  end

end