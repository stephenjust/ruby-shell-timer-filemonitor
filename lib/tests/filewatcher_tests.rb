require 'test/unit'
require_relative '../file_watcher'

class FileWatcherTest < Test::Unit::TestCase

  TEST_FILE = "test.txt"
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

    File.open(TEST_FILE, "w") do |file|
      file.write("opened")
    end

    sleep(SLEEP_INTERVAL)

    assert(isComplete, "Failed to register the file creation before the test timed out!")
  end

  def testListenAlter
    File.open(TEST_FILE, "w") do |file|
      file.write("open")
    end

    isComplete = false
    @fw.listen_for_alteration([TEST_FILE], 0) do |fileName|
      assert fileName.include? TEST_FILE
      isComplete = true
    end

    File.open(TEST_FILE, "w") do |file|
      file.write("modified")
    end

    sleep(SLEEP_INTERVAL)

    assert(isComplete, "Failed to register the file creation before the test timed out!")
  end

  def testListenDelete

    File.open(TEST_FILE, "w") do |file|
      file.write("open")
    end

    isComplete = false
    @fw.listen_for_delete([TEST_FILE], 0.05) do |fileName|
      assert fileName.include? TEST_FILE
      isComplete = true
    end

    File.delete(TEST_FILE) if File.exists?(TEST_FILE)

    sleep(SLEEP_INTERVAL)

    assert(isComplete, "Failed to register the file deletion before the test timed out!")
  end

end
