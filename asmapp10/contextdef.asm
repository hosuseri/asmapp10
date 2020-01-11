;;; stack frame
	.EQU f_rethi	= 4
	.EQU f_retlo	= 3
	.EQU f_r28	= 2
	.EQU f_r29	= 1

;;; context
	.EQU c_r0	= 0
	.EQU c_r1	= 1
	.EQU c_r2	= 2
	.EQU c_r3	= 3
	.EQU c_r4	= 4
	.EQU c_r5	= 5
	.EQU c_r6	= 6
	.EQU c_r7	= 7
	.EQU c_r8	= 8
	.EQU c_r9	= 9
	.EQU c_r10	= 10
	.EQU c_r11	= 11
	.EQU c_r12	= 12
	.EQU c_r13	= 13
	.EQU c_r14	= 14
	.EQU c_r15	= 15
	.EQU c_r16	= 16
	.EQU c_r17	= 17
	.EQU c_r18	= 18
	.EQU c_r19	= 19
	.EQU c_r20	= 20
	.EQU c_r21	= 21
	.EQU c_r22	= 22
	.EQU c_r23	= 23
	.EQU c_r24	= 24
	.EQU c_r25	= 25
	.EQU c_r26	= 26
	.EQU c_r27	= 27
	.EQU c_r28	= 28
	.EQU c_r29	= 29
	.EQU c_r30	= 30
	.EQU c_r31	= 31
	.EQU c_sreg	= 32
	.EQU c_spl	= 33
	.EQU c_sph	= 34
	.EQU c_pcl	= 35
	.EQU c_pch	= 36
	.EQU c_size	= 37

	.MACRO ENTER
	push	r29
	push	r28
	in	r28, SPL
	in	r29, SPH
	.ENDMACRO

	.MACRO LEAVE
	out	SPL, r28
	out	SPH, r29
	pop	r28
	pop	r29
	ret
	.ENDMACRO

