module tracer

#include <sys/ptrace.h>
#include <unistd.h>
#include <sys/user.h>

struct C.user_regs_struct {
pub:
	orig_rax i64 // syscall number
	rax      i64 // ret
	rbx      i64
	rcx      i64
	rdi      i64 // 1st arg
	rsi      i64 // 2nd arg
	rdx      i64 // 3rd arg
	r8       i64
	r9       i64
	r10      i64
}

type UserRegs = C.user_regs_struct

fn (u &UserRegs) str() string {
	return 'regs {rdi: ${u.rdi.hex()}, rsi: ${u.rsi.hex()}, rdx: ${u.rdx.hex()}}'
}

fn C.ptrace(u64, u32, voidptr, voidptr) i64
fn C.execv(&char, &&char) int

pub struct Ptracer {
mut:
	pid             int
	syscall_tracing bool
	syscall_hook    fn (int, UserRegs) = unsafe { nil }
}

pub fn (p &Ptracer) trace_me() i64 {
	return C.ptrace(ptrace_traceme, 0, unsafe { nil }, unsafe { nil })
}

pub fn (p &Ptracer) set_options(pid int, option u64) i64 {
	return C.ptrace(ptrace_setoptions, pid, unsafe { nil }, option)
}

pub fn (p &Ptracer) attach(pid int) i64 {
	return C.ptrace(ptrace_attach, pid, unsafe { nil }, unsafe { nil })
}

pub fn (p &Ptracer) dettach(pid int) i64 {
	return C.ptrace(ptrace_detach, pid, unsafe { nil }, unsafe { nil })
}

pub fn (p &Ptracer) syscall(pid int) i64 {
	return C.ptrace(ptrace_syscall, pid, unsafe { nil }, unsafe { nil })
}

pub fn (p &Ptracer) get_regs(pid int) C.user_regs_struct {
	mut regs := C.user_regs_struct{}
	C.ptrace(ptrace_getregs, pid, unsafe { nil }, &regs)
	return regs
}

pub fn (p &Ptracer) cont(pid int, signo int) i64 {
	return C.ptrace(ptrace_cont, pid, 0, signo)
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
		if wifstopped(status) {
			break
		}
		match wstopsig(status) {
			1,  // SIGHUP
			11,  // SIGSEGV
			2 // SIGINT
			{
				p.cont(child, wstopsig(status))
				exit(1)
			}
			5 // SIGTRAP (syscall entry, syscall exit, child calls exec)
			{
				if p.syscall_tracing {
					if in_call == 0 {
						regs := p.get_regs(child)
						p.syscall_hook(int(regs.orig_rax), regs)
						in_call = 1
					} else {
						in_call = 0
					}
				}
			}
			else {}
		}
	}
}
