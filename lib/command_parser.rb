require 'csv'
require_relative 'contracts/shell_contract'

module CommandParser
  include Contracts::CommandParser

  def parse(cmd)
    pre_parse(cmd)
    matches = cmd.scan(/\w+|"(?:\\"|[^"])+"/)
    matches.map! {|x| x.strip}
    post_parse(matches)
    matches
  end

end
