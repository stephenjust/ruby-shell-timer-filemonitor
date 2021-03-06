require 'test/unit/assertions'

module Contracts
  module Shell
    include Test::Unit::Assertions

    def pre_init(directory)
      pre_cd(directory)
    end

    def pre_execute_cmd(cmd)
      assert_not_nil cmd
    end

    def pre_is_internal_cmd(cmd)
      assert_not_nil @internal_cmds
      assert cmd.respond_to?(:[])
    end

    def pre_run(cmdInput)
      assert_not_nil cmdInput
      assert self.is_valid_cmd(cmdInput?)
    end

    def pre_execute_internal(cmd)
      assert_not_nil @internal_cmds[cmd[0]]
    end

    def pre_cd(target)
      assert_not_nil target
    end

    def post_pwd(result)
      assert result.respond_to?(:to_s), "pwd must be convertible to a string"
    end

    def class_invariant
      assert self.respond_to?(:execute_cmd), "Shell must support execute_cmd"
      assert self.respond_to?(:is_internal_cmd?), "Shell must support is_internal_cmd?"
      assert self.respond_to?(:run) , "Shell must support run"
      assert self.respond_to?(:cd), "FileWatcher must support cd"
      assert self.respond_to?(:pwd), "FileWatcher must support pwd"
      assert(File.directory?(@pwd), "Current path #{@pwd} must be a directory.")
    end
  end

  module CommandParser
    include Test::Unit::Assertions

    def pre_parse(cmd)
      assert_not_nil cmd, "Command may not be nil!"
    end

    def post_parse(matches)
      assert_not_nil matches, "Parsed command was nil!"
    end
  end
end
