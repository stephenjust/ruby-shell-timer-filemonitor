require 'shellwords'
require_relative 'contracts/shell_contract'

module CommandParser
  include Contracts::CommandParser

  def parse(cmd)
    pre_parse(cmd)
    begin
      matches = Shellwords.shellsplit(cmd)
    rescue ArgumentError
      matches = []
    end
    post_parse(matches)
    return matches
  end

  def format_for_exec(cmd)
    pre_format_for_exec(cmd)
    cmd = cmd.insert(1, "\0") # Null character for argv[1]
    post_format_for_exec(cmd)
    return cmd
  end

end
