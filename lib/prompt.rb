require_relative 'contracts/shell_contract'
require_relative 'command_parser'

class Prompt # Name 'Shell' is taken
  include Contracts::Shell
  include CommandParser

  def initialize(directory)
    pre_init(directory)
    @pwd = directory or '/'
    @internal_cmds = {
      "cd" => :cd,
      "exit" => :exit,
      "pwd" => :pwd
    }
    class_invariant
  end

  def ps1
    "shell:#{@pwd} $ "
  end

  def run
    loop do
      class_invariant
      input = prompt_input
      cmd = parse(input)
      next if cmd.size == 0
      fmt_cmd = format_for_exec(cmd)
      if is_internal_cmd?(fmt_cmd)
        execute_internal(fmt_cmd)
      else
        pid = fork { execute_cmd(fmt_cmd) }
        begin
          Process.waitpid(pid)
        rescue Interrupt
          Process.kill("SIGINT", pid)
        end
      end
      class_invariant
    end
  end

  def prompt_input
    class_invariant
    print ps1
    command = gets.chomp
    class_invariant
    return command
  end

  def execute_cmd(cmd)
    class_invariant
    pre_execute_cmd(cmd)
    begin
      env = {"PWD" => @pwd}
      exec(env, [cmd[0], cmd[1]], *cmd[2..-1], :unsetenv_others=>true, :chdir=>@pwd)
    rescue Errno::ENOENT
      puts "Command '#{cmd[0]}' not found."
    end
    class_invariant
  end

  def execute_internal(cmd)
    class_invariant
    begin
      send(@internal_cmds[cmd[0]], *cmd[2..-1])
    rescue ArgumentError
      puts "Invalid arguments"
    end
    class_invariant
  end
  
  def is_internal_cmd?(cmd)
    pre_is_internal_cmd(cmd)
    @internal_cmds.include?(cmd[0])
  end

  def is_valid_cmd?; end

  def cd(dir)
    class_invariant
    pre_cd(dir)
    @pwd = File.absolute_path(dir)
    class_invariant
  end

  def pwd
    puts @pwd
  end

  def exit
    puts "Exiting"
    Kernel.exit
  end
end
