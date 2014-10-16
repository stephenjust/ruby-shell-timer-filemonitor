require 'test/unit/assertions'

module Contracts
  module Shell
    include Test::Unit::Assertions

    def class_invariant
      assert(File.directory?(@pwd), "Current path #{@pwd} must be a directory.")
    end

  end

end
