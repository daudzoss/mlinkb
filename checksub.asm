tempchk	.fill	1		;
unsolvd	lda	#0		;
	rts			;
checkt	.macro	offset		;inline uint1_t checkt(uint4_t offset) {
	bit	state+\offset	; if (state[offset] & 0xc0 != 0x80)
	bpl	unsolvd		;  return 0; // give up since not a TOPLINK
	bvs	unsolvd		; else return 1; // otherwise, keep checking
	.endm			;} // checkt()
checkb	.macro	offset		;inline uint1_t checkt(uint4_t offset) {
	bit	state+\offset	; if (state[offset] & 0xc0 != 0xc0)
	bpl	unsolvd		;  return 0; // give up since not a BOTLINK
	bvc	unsolvd		; else return 1; // otherwise, keep checking
	.endm			;} // checkb()
checkc	.macro	offset		;inline uint1_t checkc(uint4_t offset) {
	lda	state+\offset+0	;
	and	#$3f		;
	sta	tempchk		; tempchk = state[offset] & 0x3f; // color bits
	lda	state+\offset+1	;
	beq	+		; if (state[offset+1] == 0 ||
	and	#$3f		;
	cmp	tempchk		;
	beq	+		;     (state[offset+1] & 0x3f != tempchk))
	jmp	unsolvd		;  return 0;
+	lda	state+\offset+2	;
	beq	+		; else if (state[offset+2] == 0 ||
	and	#$3f		;
	cmp	tempchk		;
	beq	+		;     (state[offset+2] & 0x3f != tempchk))
	jmp	unsolvd		;  return 0;
+	lda	state+\offset+3	;
	and	#$3f		; else if (state[offset+3] != tempchk)
	cmp	tempchk		;  return 0;
	beq	+		; else
	jmp	unsolvd		;  return 1;
+
	.endm			;} // checkc()

checkok	checkt	0		;uint1_t checkok(void) {
	checkt	4		; return checkt(0) &&
	checkt	8		;        checkt(4) &&
	checkt	$c		;        checkt(8) &&
	checkb	3		;        checkt(12) && // TOPLINK atop columns
	checkb	7		;        checkb(3) &&
	checkb	$b		;        checkb(7) &&
	checkb	$f		;        checkb(11) &&
	checkc	0		;        checkb(15) && // BOTLINK under columns
	checkc	4		;        checkc(0) &&
	checkc	8		;        checkc(4) &&
	checkc	$c		;        checkc(8) &&
	lda	#1		;        checkc(12); // one color per column
	rts			;} // checkok()
