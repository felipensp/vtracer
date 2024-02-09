module tracer

pub const ptrace_o_exitkill = 0x00100000

pub const ptrace_traceme = 0
pub const ptrace_cont = 7
pub const ptrace_kill = 8
pub const ptrace_getregs = 12
pub const ptrace_attach = 16
pub const ptrace_detach = 17
pub const ptrace_syscall = 24
pub const ptrace_setoptions = 0x4200
