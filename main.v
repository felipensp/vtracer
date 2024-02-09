module main

import tracer
import os

fn find_syscall_64(syscall int) string {
	return match syscall {
		0 { 'read' }
		1 { 'write' }
		2 { 'open' }
		3 { 'close' }
		4 { 'stat' }
		5 { 'fstat' }
		8 { 'lseek' }
		9 { 'mmap' }
		10 { 'mprotect' }
		11 { 'munmap' }
		12 { 'brk' }
		13 { 'sigaction' }
		21 { 'access' }
		59 { 'execve' }
		60 { 'exit' }
		61 { 'wait4' }
		62 { 'kill' }
		158 { 'arch_prctl' }
		228 { 'clock_gettime' }
		257 { 'openat' }
		else { '#${syscall}' }
	}
}

fn syscall_hook(syscall int, user_regs tracer.UserRegs) {
	sys_name := find_syscall_64(syscall)
	eprintln('${sys_name}(${user_regs.rdi}) = ${user_regs.rax}')
}

fn main() {
	mut vtracer := tracer.Ptracer{
		syscall_tracing: true
		syscall_hook: syscall_hook
	}
	mut args := unsafe { [2]&char{} }
	args[0] = if os.args.len > 2 { os.args[2].str } else { &char(''.str) }
	args[1] = unsafe { nil }
	vtracer.trace(os.args[1], &args[0])
}
