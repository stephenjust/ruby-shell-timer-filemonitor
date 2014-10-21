require 'shellwords'
require_relative 'contracts/shell_contract'

module CommandParser
  include Contracts::CommandParser

  def parse(cmd)
    pre_parse(cmd)
    matches = Shellwords.shellsplit(cmd)
    post_parse(matches)
    matches
  end

end
