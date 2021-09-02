.nolist
.include "m328Pdef.inc"
.list

.def t0 = r16

start:
;Turn on PD3 and PD5
	ldi t0, (1<<PORTD3) | (1<<PORTD5)
	out DDRD, t0
	ldi t0, (0<<PORTD3) | (1<<PORTD5)
	out PORTD, t0


end:
	rjmp end