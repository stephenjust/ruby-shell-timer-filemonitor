# ECE 421 Assignment 2
# Jesse Tucker, Stephen Just
#
# System Shell, Timer, File Watcher

require_once 'lib/prompt'

# You can execute part 1 of the assignment on its own by running
# the script called "shell".
#
# Use of the shell is simple: type commands as you would in bash.
# A couple of internal commands are supported: 'cd', 'pwd', 'exit'.
#
# Running scripts automatically is not supported. Instead run
# 'sh ./someFile.sh'. Output redirection is not supported. Pipes are
# not supported. Multi-line input is not supported. Expansion of ~ in paths
# does not work.
#
# For "security", environment variables are not passed to the executed
# program except for the current directory.
p = Prompt.new('/')
p.run

# To run Part 2, the timer:
# cd ./lib
# ruby timer_driver.rb "My Delayed Message" 2500
#
# Note: 2500 is in milliseconds

# To run Part 3, the file watcher:
# cd ./lib
# ruby file_watch_driver.rb created_file modified_file deleted_file duration
# Eg. ruby file_watch_driver.rb foo.txt bar.txt foobar.txt 100
#
# Note: 100 is in seconds