module tracer

@[inline]
fn wifstopped(status int) bool {
	return (status & 0xff) != 0x7f
}

@[inline]
fn wstopsig(status int) int {
	return (status & 0xff00) >> 8
}
