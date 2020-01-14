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
	std	z + c_r0, r0
	in	r0, SREG
	std	z + c_sreg, r0
	std	z + c_r28, r28
	std	z + c_r29, r29
	;; return
	pop	r28
	pop	r29
	;; continue
	pop	r0
	std	z + c_pcl, r0
	pop	r0
	std	z + c_pch, r0
	;; r30
	pop	r0
	std	z + c_r30, r0
	;; r31
	pop	r0
	std	z + c_r31, r0
	;;
	cli
	in	r0, SPL
	std	z + c_spl, r0
	in	r0, SPH
	std	z + c_sph, r0
	;; restore the return
	push	r29
	push	r28
	;;
save_gregs:
	ld	r0, z
	st	z+, r0
	st	z+, r1
	st	z+, r2
	st	z+, r3
	st	z+, r4
	st	z+, r5
	st	z+, r6
	st	z+, r7
	st	z+, r8
	st	z+, r9
	st	z+, r10
	st	z+, r11
	st	z+, r12
	st	z+, r13
	st	z+, r14
	st	z+, r15
	st	z+, r16
	st	z+, r17
	st	z+, r18
	st	z+, r19
	st	z+, r20
	st	z+, r21
	st	z+, r22
	st	z+, r23
	st	z+, r24
	st	z+, r25
	st	z+, r26
	st	z+, r27
	ret
;;; 
init_context:
	std	z + c_r0, r0
	in	r0, SREG
	std	z + c_sreg, r0
	std	z + c_r28, r28
	std	z + c_r29, r29
	;; return
	pop	r28
	pop	r29
	;; continue
	pop	r0
	std	z + c_pcl, r0
	pop	r0
	std	z + c_pch, r0
	;; r30
	pop	r0
	std	z + c_r30, r0
	;; r31
	pop	r0
	std	z + c_r31, r0
	;;
	;; restore the return
	push	r29
	push	r28
	;;
	rjmp	save_gregs

;;;
;;; r31:r30 = context
;;;
restore_context:
	ldd	r28, z + c_spl
	ldd	r29, z + c_sph
	cli
	out	SPL, r28
	out	SPH, r29
	;;
	;; continue
	ldd	r28, z + c_pcl
	ldd	r29, z + c_pch
	;; what is happening? Big endian on the stack?
	push	r28
	push	r29
	;; r30, r31
	ldd	r28, z + c_r30
	ldd	r29, z + c_r31
	push	r29
	push	r28
	;; SREG
	ldd	r28, z + c_sreg
	push	r28
	;;
	ld	r0, z+
	ld	r1, z+
	ld	r2, z+
	ld	r3, z+
	ld	r4, z+
	ld	r5, z+
	ld	r6, z+
	ld	r7, z+
	ld	r8, z+
	ld	r9, z+
	ld	r10, z+
	ld	r11, z+
	ld	r12, z+
	ld	r13, z+
	ld	r14, z+
	ld	r15, z+
	ld	r16, z+
	ld	r17, z+
	ld	r18, z+
	ld	r19, z+
	ld	r20, z+
	ld	r21, z+
	ld	r22, z+
	ld	r23, z+
	ld	r24, z+
	ld	r25, z+
	ld	r26, z+
	ld	r27, z+
	ld	r28, z+
	ld	r29, z+
	pop	r30
	out	SREG, r30
	pop	r30
	pop	r31
	ret
