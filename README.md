# vtracer
Ptrace interface for writing tracing tools in V and tracing tool.

This project aims to provide an interface to who want write a tracing tool using ptrace in high level way.

The `main.v` is a sample how to use the wrapper.

_Work in progress state. Only Linux x86-64 support yet._

### Building

`$ v .`

### Using the vtracer

```
$ ./vtracer /bin/date
[+] starting and tracing `/bin/date`
execve(0) = 0
brk(0) = 140737064759296
access(140639249576704) = -2
openat(4294967196) = 3
fstat(3) = 0
mmap(0) = 140639249346560
close(3) = 0
openat(4294967196) = 3
read(3) = 832
fstat(3) = 0
mmap(0) = 140639249301504
mmap(0) = 140639247466496
mprotect(140639247605760) = 0
mmap(140639247605760) = 140639247605760
mmap(140639248945152) = 140639248945152
mmap(140639249260544) = 140639249260544
mmap(140639249285120) = 140639249285120
close(3) = 0
arch_prctl(4098) = 0
mprotect(140639249260544) = 0
mprotect(140639249739776) = 0
mprotect(140639249592320) = 0
munmap(140639249346560) = 0
brk(0) = 140737064759296
brk(140737064894464) = 140737064894464
openat(4294967196) = 3
fstat(3) = 0
mmap(0) = 140639244431360
close(3) = 0
clock_gettime(0) = 0
openat(4294967196) = 3
fstat(3) = 0
fstat(3) = 0
read(3) = 512
lseek(3) = 545
read(3) = 512
read(3) = 413
close(3) = 0
fstat(1) = 0
Fri 09 Feb 2024 09:50:35 AM -03
write(1) = 32
close(1) = 0
close(2) = 0
```
