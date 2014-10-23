require './Timer/delayed_print'
include DelayedPrint

msg = ARGV[0] if ARGV.length >= 1
delay = ARGV[1].to_i if ARGV.length >= 2

if msg != nil && delay != nil
  Process.daemon(true, true)
  delayed_print(delay, msg)
else
  puts "please specify a message and a delay!"
  puts "Rxed : Msg: #{msg}, Delay: #{delay}"
end
