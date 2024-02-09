module tracer

// ptrace options
pub const ptrace_o_tracesysgood = 0x00000001
pub const ptrace_o_tracefork = 0x00000002
pub const ptrace_o_tracevfork = 0x00000004
pub const ptrace_o_traceclone = 0x00000008
pub const ptrace_o_traceexec = 0x00000010
pub const ptrace_o_tracevforkdone = 0x00000020
pub const ptrace_o_traceexit = 0x00000040
pub const ptrace_o_traceseccomp = 0x00000080
pub const ptrace_o_exitkill = 0x00100000
pub const ptrace_o_suspend_seccomp = 0x00200000
pub const ptrace_o_mask = 0x003000ff

// ptrace request type
pub const ptrace_traceme = 0
pub const ptrace_peektext = 1
pub const ptrace_peekdata = 2
pub const ptrace_peekuser = 3
pub const ptrace_poketext = 4
pub const ptrace_pokedata = 5
pub const ptrace_pokeuser = 6
pub const ptrace_cont = 7
pub const ptrace_kill = 8
pub const ptrace_singlestep = 9
pub const ptrace_getregs = 12
pub const ptrace_setregs = 13
pub const ptrace_getfpregs = 14
pub const ptrace_setfpregs = 15
pub const ptrace_attach = 16
pub const ptrace_detach = 17
pub const ptrace_getfpxregs = 18
pub const ptrace_setfpxregs = 19
pub const ptrace_syscall = 24
pub const ptrace_get_thread_area = 25
pub const ptrace_set_thread_area = 26
pub const ptrace_setoptions = 0x4200
// others...
