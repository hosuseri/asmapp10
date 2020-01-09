;
; asmapp10.asm
;

/* Fuse Settings
 * EXTENDED 0xFF
 * HIGH     0xD9
 * LOW      0xF0
 */

#ifndef RAMSTART
#define RAMSTART 0x0100
#endif

#ifndef RAMEND
#define RAMEND 0x08ff
#endif

#define RAMSIZE (RAMEND + 1 - RAMSTART)

	.CSEG
	.ORG 0
	jmp start
	.ORG 0x001c
	jmp tim0_mat
;;;
	.ORG 0x0034
start:
	clr r2
	mov r3, r2
	inc r3
	;;
	ldi r16, LOW(RAMEND)
	out SPL, r16
	ldi r16, HIGH(RAMEND)
	out SPH, r16
	;; 
	out SPCR, r2
	;;
	ldi r30, LOW(RAMSTART)
	ldi r31, HIGH(RAMSTART)
	ldi r16, LOW(RAMSIZE)
	ldi r17, HIGH(RAMSIZE)
ramclr:
	st x+, r2
	sub r16, r3
	sbc r17, r2
	mov r0, r16
	or r0, r17
	brne ramclr
	;; 
	;; setting-up clock pre-scaler
	ldi r26, LOW(CLKPR)
	ldi r27, HIGH(CLKPR)
	clr r0
	set
	bld r0, CLKPCE
	st x, r0
	st x, r2
	;; 
	;; setting-up PORTB direction
	clr r0
	set
	bld r0, DDB5
	out DDRB, r0
	;;
	;; setting-up PORTC direction
	ldi r16, 0x0f
	out DDRC, r16
	out PORTC, r2
	;;
	;; setting-up TIMER0
	ldi r16, (0<<COM0A1) | (0<<COM0A0) | (1<<WGM01) | (0<<WGM00)
	out TCCR0A, r16
	ldi r16, (0<<WGM02) | (1<<CS02) | (0<<CS01) | (0<<CS00)
	out TCCR0B, r16
	ldi r16, 78
	out OCR0A, r16
	;;
	ldi r26, LOW(TIMSK0)
	ldi r27, HIGH(TIMSK0)
	clr r0
	set
	bld r0, OCIE0A
	st x, r0
	;;
	;; enable interrupt
	sei
	;;
	;; Z has systicks
	ldi r30, LOW(systicks)
	ldi r31, HIGH(systicks)
	;;
	ldi r16, 9
	mov r0, r16
	ldi r16, 8
	mov r1, r16
	rcall emit_light
	;;
	ldi r16, 8
	mov r0, r16
	ldi r16, 4
	mov r1, r16
	rcall emit_light
	;;
	ldi r16, 7
	mov r0, r16
	ldi r16, 2
	mov r1, r16
	rcall emit_light
	;;
	ldi r16, 6
	mov r0, r16
	ldi r16, 1
	mov r1, r16
	rcall emit_light
	;; 
	;; for testing
#if 0
	ldi r16, 0x71
	std z+8, r16
	ldi r16, 0x51
	std z+9, r16
	ldi r16, 0x01
	std z+10, r16
#endif
	;; 
	ldi r24, 8
	mov r25, r2
	clr r0
	rjmp prn_tim
wait_edge:
	ld r16, z
	cp r16, r25
	breq wait_edge
wait_edge_10:
	mov r25, r16
	andi r16, 3
	brne wait_edge_20
	sbrc r24, 3
	ldd r0, z+15
	sbrc r24, 2
	ldd r0, z+14
	sbrc r24, 1
	ldd r0, z+13
	sbrc r24, 0
	ldd r0, z+12
	mov r1, r24 
	rcall emit_light
	lsr r24
	brcc wait_edge_20
	ldi r24, 8
wait_edge_20:
	ldd r0, z+11
	cp r0, r14
	breq wait_edge
	;;
prn_tim:
	mov r14, r0
	cli
	ldd r8, z+8
	ldd r9, z+9
	ldd r10, z+10
	sei
	;;
	ldi r16, 60
	mov r4, r16
	rcall udiv2408
	std z+12, r0
	;; 
	ldi r16, 60
	mov r4, r16
	rcall udiv2408
	std z+14, r0
	;;
	ldi r16, 24
	mov r4, r16
	rcall udiv1608
	std z+16, r0
	;;
	ldd r8, z+12
	ldi r16, 10
	mov r4, r16
	call udiv0808
	std z+12, r0
	std z+13, r8
	;;
	ldd r8, z+14
	ldi r16, 10
	mov r4, r16
	call udiv0808
	std z+14, r0
	std z+15, r8
	;;
	ldd r8, z+16
	ldi r16, 10
	mov r4, r16
	call udiv0808
	std z+16, r0
	std z+17, r8
	;;
	rjmp wait_edge
	;;
tim0_mat:
	push r0
	in r0, SREG
	push r0
	push r1
	push r16
	push r31
	push r30
	ldi r30, LOW(systicks)
	ldi r31, HIGH(systicks)
	;;
tim0_mat10:
	ld r0, z
	add r0, r3
	st z+, r0
	ld r0, z
	adc r0, r2
	st z+, r0
	ld r0, z
	adc r0, r2
	st z+, r0
	ld r0, z
	adc r0, r2
	st z+, r0
	ld r0, z
	adc r0, r2
	st z+, r0
	ld r0, z
	adc r0, r2
	st z+, r0
	;;
	ld r0, z
	ldi r16, 66
	add r0, r16
	st z+, r0
	ld r0, z
	adc r0, r2
	st z+, r0
	brcc tim0_mat_30
	;;
	ld r0, z
	add r0, r3
	st z, r0
	ldd r0, z+1
	adc r0, r2
	std z+1, r0
	ldd r0, z+2
	adc r0, r2
	std z+2, r0
	;;
	ldd r0, z+3
	ldi r16, 1<<DDB5
	eor r0, r16
	std z+3, r0
	out PORTB, r0
	;;
tim0_mat_30:
	pop r30
	pop r31
	pop r16
	pop r1
	pop r0
	out SREG, r0
	pop r0
	reti
	;;
	;; R8 / R4
	;; R8 <= quotient
	;; R0 <= remainder
	;; breaks: R16
udiv0808:
	clr r0
	ldi r16, 8
udiv0808_10:
	lsl r8
	rol r0
	cp r0, r4
	brcs udiv0808_20
	inc r8
	sub r0, r4
udiv0808_20:
	dec r16
	brne udiv0808_10
	ret
	;;
	;; R9:R8 / R4
	;; R9:R8 <= quotient
	;; R0    <= remainder
	;; breaks: R16
udiv1608:
	clr r0
	ldi r16, 16
udiv1608_10:
	lsl r8
	rol r9
	rol r0
	cp r0, r4
	brcs udiv1608_20
	inc r8
	sub r0, r4
udiv1608_20:
	dec r16
	brne udiv1608_10
	ret
	;;
	;; R10:R9:R8 / R4
	;; R10:R9:R8 <= quotient
	;; R0    <= remainder
	;; breaks: R16
udiv2408:
	clr r0
	ldi r16, 24
udiv2408_10:
	lsl r8
	rol r9
	rol r10
	rol r0
	cp r0, r4
	brcs udiv2408_20
	inc r8
	sub r0, r4
udiv2408_20:
	dec r16
	brne udiv2408_10
	ret
	;;
emit_light:
	push r31
	push r30
	push r17
	push r16
	push r4
	push r1
	push r0
	ldi r30, LOW(seven_seg<<1)
	ldi r31, HIGH(seven_seg<<1)
	add r30, r0
	adc r31, r2
	lpm
	lsl r0
	rol r1
	lsl r0
	rol r1
	lsl r0
	rol r1
	lsl r0
	rol r1
	ldi r17, 2
	ldi r16, 12
emit_light_10:
	mov r4, r2
	lsl r0
	rol r1
	rol r4
	out PORTC, r4
	or r4, r17
	out PORTC, r4
	dec r16
	brne emit_light_10
	ldi r17, 8
	out PORTC, r17
	ldi r17, 4
	out PORTC, r17
	out PORTC, r2
	;; 
	pop r0
	pop r1
	pop r4
	pop r16
	pop r17
	pop r30
	pop r31
	ret
;;;
seven_seg:
	.DB 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6d, 0x7d, 0x27
	.DB 0x7f, 0x6f, 0x77, 0x7c, 0x39, 0x5e, 0x79, 0x71
;;;
	.DSEG
	.ORG RAMSTART
systicks:
	.BYTE 6
	.BYTE 2
seconds:
	.BYTE 4
minsec:
	.BYTE 6			; sec., min., hour
