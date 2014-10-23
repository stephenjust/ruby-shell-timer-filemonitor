#include <stdio.h>

#include "time.h"
#include "ruby.h"

VALUE Timer = Qnil;

void Init_delayed_print();
VALUE method_delayed_print(VALUE self, VALUE delay, VALUE msg);

void Init_delayed_print()
{
  Timer = rb_define_module("DelayedPrint");
  rb_define_method(Timer, "delayed_print", method_delayed_print, 2);
}

VALUE method_delayed_print(VALUE self, VALUE delay, VALUE msg)
{
  int result;
  VALUE msg_s;
  ID sym_puts;
  struct timespec time;
  int ms;
  ms = NUM2INT(delay);
  time.tv_sec = ms / 1000;
  time.tv_nsec = (ms % 1000) * 1000000;

  result = nanosleep(&time, NULL);

  if(result != 0)
  {
    // throw ruby exception
    rb_raise(rb_eInterrupt, "Sleep was interrupted!");
  }
  else
  {
    msg_s = StringValue(msg);
    sym_puts = rb_intern("puts");
    rb_funcall(Qnil, sym_puts, 1, msg_s);
  }

  return msg;
}
