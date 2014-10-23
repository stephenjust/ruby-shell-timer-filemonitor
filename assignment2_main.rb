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

