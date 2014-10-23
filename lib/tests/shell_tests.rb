require 'test/unit'
require 'stringio'
require_relative '../command_parser'
require_relative '../prompt'

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

class PromptTest < Test::Unit::TestCase

  def setup
    @p = Prompt.new('/')
  end

  def testExecuteInternal
    $stdout = StringIO.new
    @p.execute_internal(["pwd"])
    assert_equal "/\n", $stdout.string
  end

  def testPwd
    $stdout = StringIO.new
    @p.pwd
    assert_equal "/\n", $stdout.string
  end

  def testCd
    $stdout = StringIO.new
    @p.cd("../../../")
    @p.pwd
    @p.cd("/home/")
    @p.pwd
    assert_equal "/\n/home\n", $stdout.string
  end
end
