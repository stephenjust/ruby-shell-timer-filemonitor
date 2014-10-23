require 'test/unit'
require_relative '../command_parser'

class CommandParserTest < Test::Unit::TestCase
  include CommandParser
  
  def testParse
    good_strings = [
      "foo bar bat baz",
      "cd",
      "/bin/bash",
      "echo \"foo bar\"",
      "echo 'foo bar \" bat'",
      "ls | grep foo"
    ]
    good_output = [
      ["foo", "bar", "bat", "baz"],
      ["cd"],
      ["/bin/bash"],
      ["echo", "foo bar"],
      ["echo", "foo bar \" bat"],
      ["ls", "|", "grep", "foo"]
    ]
    good_strings.length.times do |i|
      assert_equal parse(good_strings[i]), good_output[i]
    end
  end

  def testParseBad
    bad_strings = [
      "a \"",
      "b '"
    ]
    bad_strings.length.times do |i|
      assert_equal parse(bad_strings[i]), []
    end
  end 

end
