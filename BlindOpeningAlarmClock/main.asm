.nolist
.include "m328Pdef.inc"
.list

.def t0 = r16
.def t1 = r17


d3_on:
	in	t1, PIND	;load in current value of PIND
	ldi t0, (1<<PORTD3)	;set bit for pin 3
	or	t0, t1
	out DDRD, t0	;set direction of pins 
	ldi t0, (1<<PORTD3)
	out PORTD, t0

end:
	rjmp end