.nolist
.include "m328Pdef.inc"
.list

.def t0 = r16

;Turn on PB4
	ldi t0, (1<<PORTB4)
	out DDRB, t0
	out PORTB, t0

;Turn on PC4
	ldi t0, (1<<PORTC4)
	out DDRC, t0
	out PORTC, t0

;Turn on PD4
	ldi t0, (1<<PORTD4)
	out DDRD, t0
	out PORTD, t0

end:
	rjmp end