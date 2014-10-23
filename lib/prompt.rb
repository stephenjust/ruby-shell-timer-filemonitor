require_relative 'contracts/shell_contract'
require_relative 'command_parser'
require 'pathname'

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

  # Generates shell prompt string
  def ps1
    "shell:#{@pwd} $ "
  end

  # Main shell loop
  def run
    loop do
      class_invariant
      begin
        input = prompt_input
      rescue Interrupt
        puts "Interrupted. Exit with 'exit'."
        next
      end
      cmd = parse(input)
      next if cmd.size == 0
      if is_internal_cmd?(cmd)
        execute_internal(cmd)
      else
        pid = fork { execute_cmd(cmd) }
        begin
          Process.waitpid(pid)
        rescue Interrupt
          Process.kill("SIGINT", pid)
        end
      end
      class_invariant
    end
  end

  # Prompt for user input
  def prompt_input
    class_invariant
    print ps1
    command = gets.chomp
    class_invariant
    return command
  end

  # Execute a binary file
  def execute_cmd(cmd)
    class_invariant
    pre_execute_cmd(cmd)
    begin
      env = {"PWD" => @pwd}
      exec(env, [cmd[0], ""], *cmd[1..-1], :unsetenv_others=>true, :chdir=>@pwd)
    rescue Errno::ENOENT
      puts "Command '#{cmd[0]}' not found."
    end
    class_invariant
  end

  # Execute an internal command
  def execute_internal(cmd)
    class_invariant
    begin
      send(@internal_cmds[cmd[0]], *cmd[1..-1])
    rescue ArgumentError
      puts "Invalid arguments"
    end
    class_invariant
  end

  # Check if a command is internal
  def is_internal_cmd?(cmd)
    pre_is_internal_cmd(cmd)
    @internal_cmds.include?(cmd[0])
  end

  # Internal command 'cd'
  def cd(dir)
    class_invariant
    new_dir = Pathname.new("#{@pwd}/#{dir}").cleanpath
    pre_cd(new_dir)
    if File.directory?(new_dir)
      @pwd = File.absolute_path(new_dir)
    else
      puts "#{new_dir} is not a directory!"
    end
    class_invariant
  end

  # Internal command 'pwd'
  def pwd
    puts @pwd
  end

  # Internal command 'exit'
  def exit
    puts "Exiting"
    Kernel.exit
  end
end
