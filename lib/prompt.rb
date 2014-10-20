require_relative 'contracts/shell_contract'

class Prompt # Name 'Shell' is taken
  include Contracts::Shell

  def initialize(directory)
    pre_init(directory)
    @pwd = directory
    @ps1 = "shell:#{@pwd} $ "
    @internal_cmds = {}
    class_invariant
  end

  def run
    loop do
      class_invariant
      input = prompt_input
      puts input
      class_invariant
    end
  end

  def prompt_input
    class_invariant
    print @ps1
    command = gets.chomp
    class_invariant
    return command
  end

  def execute_cmd; end
  def is_internal_cmd?; end
  def is_valid_cmd?; end
  def cd; end
  def pwd; return '/'; end

end
