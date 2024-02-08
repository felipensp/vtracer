module main

import tracer
import os

fn main() {
	mut vtracer := tracer.Ptracer{
		syscall_tracing: true
	}
	vtracer.init()
	mut args := unsafe { [2]&char{} }
	args[0] = if os.args.len > 2 { os.args[2].str } else { &char(''.str) }
	args[1] = unsafe { nil }
	vtracer.trace(os.args[1], &args[0])
}
