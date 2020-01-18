;;; call this normally.
;;;
;;; r31:r30 = context
;;; SP[6] = r31
;;; SP[5] = r30
;;; SP[4] = continue(H)
;;; SP[3] = continue(L)
;;; SP[2] = return(H)
;;; SP[1] = return(L)
;;; 
save_context:
	std	z + c_r26, r26
	in	r26, SREG
	std	z + c_sreg, r26
	std	z + c_r27, r27
	std	z + c_r28, r28
	std	z + c_r29, r29
	;; return
	pop	r29
	pop	r28
	;; continue
	pop	r26
	pop	r27
	std	z + c_pcl, r26
	std	z + c_pch, r27
	;; r31:r30
	pop	r27
	pop	r26
	std	z + c_r30, r26
	std	z + c_r31, r27
	;;
	cli
	in	r26, SPL
	in	r27, SPH
	;; restore the return
	push	r28
	push	r29
	;;
save_gregs:
	movw	r26, r30
	st	x+, r0
	st	x+, r1
	st	x+, r2
	st	x+, r3
	st	x+, r4
	st	x+, r5
	st	x+, r6
	st	x+, r7
	st	x+, r8
	st	x+, r9
	st	x+, r10
	st	x+, r11
	st	x+, r12
	st	x+, r13
	st	x+, r14
	st	x+, r15
	st	x+, r16
	st	x+, r17
	st	x+, r18
	st	x+, r19
	st	x+, r20
	st	x+, r21
	st	x+, r22
	st	x+, r23
	st	x+, r24
	st	x+, r25
	ret
;;; 
init_context:
	std	z + c_r26, r26
	in	r26, SREG
	std	z + c_sreg, r26
	std	z + c_r27, r27
	std	z + c_r28, r28
	std	z + c_r29, r29
	;; return
	pop	r29
	pop	r28
	;; continue
	pop	r26
	pop	r27
	std	z + c_pcl, r26
	std	z + c_pch, r27
	;; r31:r30
	pop	r27
	pop	r26
	std	z + c_r30, r26
	std	z + c_r31, r27
	;; restore the return
	push	r28
	push	r29
	;;
	rjmp	save_gregs

;;;
;;; jmp to this, not call.
;;; r31:r30 = context
;;;
restore_context:
	movw	r26, r30
	ld	r0, x+
	ld	r1, x+
	ld	r2, x+
	ld	r3, x+
	ld	r4, x+
	ld	r5, x+
	ld	r6, x+
	ld	r7, x+
	ld	r8, x+
	ld	r9, x+
	ld	r10, x+
	ld	r11, x+
	ld	r12, x+
	ld	r13, x+
	ld	r14, x+
	ld	r15, x+
	ld	r16, x+
	ld	r17, x+
	ld	r18, x+
	ld	r19, x+
	ld	r20, x+
	ld	r21, x+
	ld	r22, x+
	ld	r23, x+
	ld	r24, x+
	ld	r25, x+
	ld	r28, x+
	ld	r29, x+
	movw	r26, r28
	cli
	ldd	r28, z + c_spl
	ldd	r29, z + c_sph
	out	SPL, r28
	out	SPH, r29
	;; continue
	ldd	r28, z + c_pcl
	ldd	r29, z + c_pch
	push	r28
	push	r29
	;;
	ldd	r28, z + c_r30
	ldd	r29, z + c_r31
	push	r28
	push	r29
	;; SREG
	ldd	r28, z + c_sreg
	out	SREG, r28
	ldd	r28, z + c_r28
	ldd	r29, z + c_r29
	pop	r30
	pop	r31
	ret
