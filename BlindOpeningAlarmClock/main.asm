.include "m328Pdef.inc"

start:
	ser r16
	out PORTB, r16
halt:
	rjmp halt