# vtracer
Ptrace interface for tracing tools written in V

This project aims to provide an interface to who want write a tracing tool using ptrace in high level way.

The `main.v` is a sample how to use the wrapper.

### Using the vtracer

```
$ ./vtracer /bin/date
[+] starting and tracing `/bin/date`
execve(0) = 0
brk(0) = 140737331785728
access(140243350401792) = -2
openat(4294967196) = 3
fstat(3) = 0
mmap(0) = 140243350171648
close(3) = 0
openat(4294967196) = 3
read(3) = 832
fstat(3) = 0
mmap(0) = 140243350454272
mmap(0) = 140243348291584
mprotect(140243348430848) = 0
mmap(140243348430848) = 140243348430848
mmap(140243349770240) = 140243349770240
mmap(140243350085632) = 140243350085632
mmap(140243350110208) = 140243350110208
close(3) = 0
arch_prctl(4098) = 0
mprotect(140243350085632) = 0
mprotect(140243350597632) = 0
mprotect(140243350417408) = 0
munmap(140243350171648) = 0
brk(0) = 140737331785728
brk(140737331920896) = 140737331920896
openat(4294967196) = 3
fstat(3) = 0
mmap(0) = 140243345256448
close(3) = 0
clock_gettime(0) = 0
openat(4294967196) = 3
fstat(3) = 0
fstat(3) = 0
read(3) = 512
#8(3) = 545
read(3) = 512
read(3) = 413
close(3) = 0
fstat(1) = 0
Fri 09 Feb 2024 08:39:02 AM -03
write(1) = 32
close(1) = 0
close(2) = 0
```