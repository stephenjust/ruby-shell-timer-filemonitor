require 'test/unit'
require_relative '../file_watcher'

class CommandParserTest < Test::Unit::TestCase

  TEST_FILE = "test.txt"
  TIMEOUT = 10
  SLEEP_INTERVAL = 1

  def setup
    @fw = FileWatcher.new()

    #ensure the file does not exist
    File.delete(TEST_FILE) if File.exists?(TEST_FILE)
  end

  def teardown
    File.delete(TEST_FILE) if File.exists?(TEST_FILE)
  end

  def testListenCreate
    isComplete = false
    @fw.listen_for_creation([TEST_FILE], 0.05) do |fileName|
      assert fileName.include? TEST_FILE
      isComplete = true
    end

    File.open(TEST_FILE, "w") do ||
    end

    TIMEOUT.times do ||
      break if isComplete
      sleep(SLEEP_INTERVAL)
    end

    assert(isComplete, "Failed to register the file creation before the test timed out!")
  end

  def testListenAlter
    isComplete = false
    @fw.listen_for_alteration([TEST_FILE], 0.05) do |fileName|
      assert fileName.include? TEST_FILE
      isComplete = true
    end

    File.open(TEST_FILE, "w") do |file|
      file.write("open")
    end

    TIMEOUT.times do ||
      File.open(TEST_FILE, "w") do |file|
        file.write("modified")
      end

      break if isComplete
      sleep(SLEEP_INTERVAL)
    end

    assert(isComplete, "Failed to register the file creation before the test timed out!")
  end

  def testListenDelete
    isComplete = false
    @fw.listen_for_alteration([TEST_FILE], 0.05) do |fileName|
      assert fileName.include? TEST_FILE
      isComplete = true
    end

    File.open(TEST_FILE, "w") do |file|
      file.write("open")
    end

    TIMEOUT.times do ||
      File.delete(TEST_FILE) if File.exists(TEST_FILE)

      break if isComplete
      sleep(SLEEP_INTERVAL)
    end

    assert(isComplete, "Failed to register the file creation before the test timed out!")
  end

end
