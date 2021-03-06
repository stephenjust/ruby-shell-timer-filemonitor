# File-Watch Driver
require_relative './file_watcher'

if ARGV.length != 4
  puts "Must provide 3 lists of files as arguments:"
  puts "create_watch_list alter_watch_list delete_watch_list duration"
  exit
end


# Daemonize the file-watcher
Process.daemon(true, true)

duration = ARGV[3].to_f

f = FileWatcher.new
f.listen_for_creation(ARGV[0].split(','), duration) { |fullPath| puts "Creation #{fullPath}"}
f.listen_for_alteration(ARGV[1].split(','), duration) { |fullPath| puts "Alteration #{fullPath}"}
f.listen_for_delete(ARGV[2].split(','), duration) { |fullPath| puts "Delete #{fullPath}"}

sleep(duration)
