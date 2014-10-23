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

end
