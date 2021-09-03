.nolist
.include "m328Pdef.inc"
.list



.dseg
hour:			.byte 1
minute:			.byte 1	
second:			.byte 1
timer_ticks:	.byte 2



.cseg

.equ ticks_in_sec = 15625
.equ sec_in_min = 60
.equ min_in_hr = 60
.equ hr_in_day = 24

.def t0 = r16
.def t1 = r17
.def t2 = r18

.org XRAMEND	
	rjmp reset
.org OVF0addr
	rcall timer_overflow



;Clear two bytes in data memory
.macro clrTwoByte 
	ldi		xl, low(@0)
	ldi		xh, high(@0)
	clr		t0
	st		x+, t0
	st		x, t0
.endmacro

; check_timer is a macro that will automatically check if a function should run based on a timer given as input
; the timer is a pair being the counter in memory and a constant to compare against
; e.g. to call this macro:
; check_timer update_lift, twoSecTimer, twoSec
; this says call update_lift when the value in twoSecTimer (a memory location) is equal to the constant twoSec
.macro check_timer
	lds		t0, @1
	lds		t1, @1 + 1

	ldi		t2, high(@2)

	cpi		t0, low(@2)
	cpc		t1, t2

	brne	check_timer_skip

	clr		t0
	sts		@1, t0
	sts		@1 + 1, t0
	
	rcall	@0

	rjmp	check_timer_end

check_timer_skip:
	ldi		t2, 1;inc instead?
	add		t0, t2
	clr		t2
	adc		t1, t2

	sts		@1, t0
	sts		@1 + 1, t1

check_timer_end:
.endmacro

timer_overflow:
	push t0

	check_timer	inc_sec, timer_ticks, ticks_in_sec

	pop	t0

inc_sec:
	check_timer	inc_min, second, sec_in_min

inc_min: 
	check_timer inc_hr, minute, min_in_hr

inc_hr:
	check_timer ret, hour, hr_in_day


reset:
;Motor control output on D3 and D5
	ldi t0, (1<<PORTD3) | (1<<PORTD5)
	out DDRD, t0

;Prescale clock by 16MHz/1024=15,625Hz
	ldi t0, (1<<CS00) | (1<<CS02)
	out TCCR0B, t0

;Enable timer overflow interupts
	ldi t0, (1<<TOIE0)
	sts TIMSK0, t0 

;Enable global interupts
	sei

;Clear 8-bit Timer/Counter0 with PWM
	clr t0
	out	TCNT0, t0
	
;Clear time buffers
	sts	hour, t0
	sts minute, t0
	sts	second, t0
	clrTwoByte timer_ticks, t0



start:
	ldi t0, (0<<PORTD3) | (1<<PORTD5)
	out PORTD, t0


end:
	rjmp end