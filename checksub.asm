tempchk	.fill	1		;
unsolvd	lda	#0		;
	rts			;
checkt	.macro	offst		;inline uint1_t checkt(uint4_t offst) {
	bit	state+\offst	; if (state[offst] & 0xc0 != 0x80)
	bpl	unsolvd		;  return 0; // give up since not a TOPLINK
	bvs	unsolvd		; else return 1; // otherwise, keep checking
	.endm			;} // checkt()
checkb	.macro	offst		;inline uint1_t checkt(uint4_t offst) {
	bit	state+\offst	; if (state[offst] & 0xc0 != 0xc0)
	bpl	unsolvd		;  return 0; // give up since not a BOTLINK
	bvc	unsolvd		; else return 1; // otherwise, keep checking
	.endm			;} // checkb()

checkc	.macro
	ldy	#0		;uint1_t checkc(void) {
-	lda	state,y		; for (register uint8_t y = 0; y < 16; y += 4) {
	and	#$3f		;
n	sta	tempchk		;  tempchk = state[y] & 0x3f; // color bits
	iny			;
	lda	state,y		;
	beq	+		;  if (state[y+1] == 0 ||
	and	#$3f		;
	cmp	tempchk		;
	beq	+		;      (state[y+1] & 0x3f != tempchk))
	jmp	unsolvd		;   return 0;
+	iny			;
	lda	state,y		;
	beq	+		;  else if (state[y+2] == 0 ||
	and	#$3f		;
	cmp	tempchk		;
	beq	+		;      (state[y+2] & 0x3f != tempchk))
	jmp	unsolvd		;  return 0;
+	iny			;
	lda	state,y		;
	and	#$3f		;  else if (state[y+3] != tempchk)
	cmp	tempchk		;   return 0;
	beq	+		;  else
	jmp	unsolvd		;   return 1;
+	iny			;
	cpy	#$10		; }
	bcc	-		;} // checkc()
	.endm

checkok	checkt	0		;uint1_t checkok(void) {
	checkt	4		; return checkt(0) &&
	checkt	8		;        checkt(4) &&
	checkt	$c		;        checkt(8) &&
	checkb	3		;        checkt(12) && // TOPLINK atop columns
	checkb	7		;        checkb(3) &&
	checkb	$b		;        checkb(7) &&
	checkb	$f		;        checkb(11) &&
	checkc			;        checkb(15) && // BOTLINK under columns
	lda	#1		;        checkc(); // one color per column
	rts			;} // checkok()
