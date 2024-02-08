module tracer

#include <sys/ptrace.h>
#include <unistd.h>
#include <sys/user.h>

const ptrace_o_exitkill = 0x00100000

const ptrace_traceme = 0
const ptrace_cont = 7
const ptrace_kill = 8
const ptrace_getregs = 12
const ptrace_attach = 16
const ptrace_detach = 17
const ptrace_syscall = 24
const ptrace_setoptions = 0x4200

struct C.user_regs_struct {
	orig_rax i64
	rax      i64
	rbx      i64
	rcx      i64
	rdx      i64
	rdi      i64
}

// type UserRegs = C.user_regs_struct

fn C.ptrace(u64, u32, voidptr, voidptr) i64
fn C.execv(&char, &&char) int

pub struct Ptracer {
mut:
	pid             int
	syscall_tracing bool
	syscall_64      map[int]string
}

pub fn (mut p Ptracer) init() {
	p.syscall_64 = map[int]string{}
	p.syscall_64[0] = 'read'
	p.syscall_64[1] = 'write'
	p.syscall_64[2] = 'open'
	p.syscall_64[3] = 'close'
	p.syscall_64[4] = 'stat'
	p.syscall_64[5] = 'fstat'
	p.syscall_64[9] = 'mmap'
	p.syscall_64[10] = 'mprotect'
	p.syscall_64[11] = 'munmap'
	p.syscall_64[12] = 'brk'
	p.syscall_64[13] = 'sigaction'
	p.syscall_64[21] = 'access'
	p.syscall_64[59] = 'execve'
	p.syscall_64[60] = 'exit'
	p.syscall_64[61] = 'wait4'
	p.syscall_64[62] = 'kill'
}

pub fn (p &Ptracer) trace_me() i64 {
	return C.ptrace(tracer.ptrace_traceme, 0, unsafe { nil }, unsafe { nil })
}

pub fn (p &Ptracer) set_options(pid int, option u64) i64 {
	return C.ptrace(tracer.ptrace_setoptions, pid, unsafe { nil }, option)
}

pub fn (p &Ptracer) attach(pid int) i64 {
	return C.ptrace(tracer.ptrace_attach, pid, unsafe { nil }, unsafe { nil })
}

pub fn (p &Ptracer) dettach(pid int) i64 {
	return C.ptrace(tracer.ptrace_detach, pid, unsafe { nil }, unsafe { nil })
}

pub fn (p &Ptracer) syscall(pid int) i64 {
	return C.ptrace(tracer.ptrace_syscall, pid, unsafe { nil }, unsafe { nil })
}

pub fn (p &Ptracer) get_regs(pid int) C.user_regs_struct {
	mut regs := C.user_regs_struct{}
	C.ptrace(tracer.ptrace_getregs, pid, unsafe { nil }, &regs)
	return regs
}

pub fn (p &Ptracer) cont(pid int, signo int) i64 {
	return C.ptrace(tracer.ptrace_cont, pid, 0, signo)
}

pub fn (mut p Ptracer) trace(file string, args &&char) int {
	eprintln('[+] starting and tracing `${file}`')
	child := C.fork()
	if child == 0 {
		p.pid = child
		trace_me := p.trace_me()
		if trace_me < 0 {
			panic('trace_me failed (${trace_me})!')
		}
		if C.execv(file.str, args) == -1 {
			panic('execv() failed')
		}
		exit(1)
	} else if child < 0 {
		panic('Error - child ${child}')
	} else {
		p.loop(child)
	}
	return child
}

pub fn (mut p Ptracer) trace_pid(pid int) int {
	p.pid = pid
	eprintln('[+] attaching to pid ${p.pid}')

	if p.attach(p.pid) < 0 {
		panic('{@FN} failed!')
	}

	p.loop(pid)
	return p.pid
}

pub fn (mut p Ptracer) loop(child int) {
	mut status := 0
	mut in_call := 0

	p.set_options(child, ptrace_o_exitkill)

	for {
		p.syscall(child)
		C.wait(&status)
		if ((status) & 0xff) != 0x7f { // WIFSTOPPED
			break
		}
		signo := ((status & 0xff00) >> 8) // WSTOPSIG
		match signo {
			1,  // SIGHUP
			11,  // SIGSEGV
			2 // SIGINT
			{
				p.cont(child, signo)
				exit(1)
			}
			5 // SIGTRAP 
			{
				regs := p.get_regs(child)
				if in_call == 0 {
					if syscall := p.syscall_64[int(regs.orig_rax)] {
						eprintln('>> ${syscall}')
					}
					in_call = 1
				} else {
					in_call = 0
				}
			}
			else {}
		}		
	}
}
