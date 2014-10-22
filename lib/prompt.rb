require_relative 'contracts/shell_contract'
require_relative 'command_parser'

class Prompt # Name 'Shell' is taken
  include Contracts::Shell
  include CommandParser

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
      cmd = parse(input)
      fmt_cmd = format_for_exec(cmd)
      pid = fork { execute_cmd(fmt_cmd) }
      Process.waitpid(pid)
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

  def execute_cmd(cmd)
    pre_execute_cmd(cmd)
    begin
      exec([cmd[0], cmd[1]], *cmd[2..-1])
    rescue Errno::ENOENT
      puts "Command '#{cmd[0]}' not found."
    end
  end

  def is_internal_cmd?; end
  def is_valid_cmd?; end
  def cd; end
  def pwd; return '/'; end

end
