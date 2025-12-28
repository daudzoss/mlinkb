missing	.byte	0		;static int4_t missing = 0;

.align	16

jumpto0	.word	allleft
jumpto1	.word	allrght
jumpto2	.word	slideup
jumpto3	.word	slidedn
jumpto4	.word	topleft
jumpto5	.word	toprght
jumpto6	.word	botleft
jumpto7	.word	botrght

jumpvec	.word	jumpto0

rndmove	lda	jumpvec		;void rndmove(void) {
	and	#$f0		;
	sta	jumpvec		;
	lda	RNDLOC1		;
	eor	RNDLOC2		;
	and	#$0e		;
	ora	jumpvec		;
	sta	jumpvec		;
rndjump	jmp	(jumpvec)	;} // rndmove()

downby1	lda	state+0		;uint4_t downby1(void) {
	sta	state+$10	; state[16] = state[0]; // temptop
	ldy	#0		;
-	lda	state+1,y	; for (register uint5_t y = 0; y < 0x10; y++)
	sta	state,y		;  state[y] = state[y+1];
	iny			;
	cpy	#$10		;
	bne	-		;
	lda	#$ff		;
	clc			;
	adc	missing		;
	bpl	+		; if (--missing < 0)
	lda	#$0f		;  missing = 15;
+	sta	missing		; return missing & 0x7f;
	rts			;} // downby1()

upby1	lda	state+$0f	;uint4_t upby1(void) {
	sta	state-1		; state[-1] = state[15]; // tempbot
	ldy	#$10		;
-	lda	state-2,y	; for (register uint5_t y = 16; y > 0; y--)
	sta	state-1,y	;  state[y-1] = state[y-2];
	dey			;
	bne	-		;
	lda	#1		;
	clc			;
	adc	missing		;
	cmp	#$10		;
	bcc	+		; if (++missing > 15)
	lda	#0		;  missing = 0;
+	sta	missing		; return missing & 0x7f;
	rts			;} // upby1()

allleft	jsr	downby1		;uint4_t allleft(void) { register uint4_t a;
	jsr	downby1		; for (int unrolled = 4; unrolled; unrolled--)
	jsr	downby1		;  a = downby1();
	jsr	downby1		; return a; // new value of missing
	rts			;} // alleft()

allrght	jsr	upby1		;uint4_t allrght(void) { register uint4_t a;
	jsr	upby1		; for (int unrolled = 4; unrolled; unrolled--)
	jsr	upby1		;  a = upby1();
	jsr	upby1		; return a; // new value of missing
	rts			;} // allrght()

slideup	rts
slidedn	rts
topleft	rts
toprght	rts
botleft	rts
botrght	rts

getmove	jsr	$ffe4		;void getmove(void) {
	beq	getmove		; switch (register char a = getchar()) {

	cmp	#'['		; case '[':
	beq	+		;
	cmp	#':'		; case ':':
	beq	+		;
	cmp	#'0'		; case '0':
	bne	++		;  return allleft(a);
+	jmp	allleft		;

+	cmp	#']'		; case ']':
	beq	+		;
	cmp	#$3b		; case ';':
	beq	+		;
	cmp	#'1'		; case '1':
	bne	++		;  return allrght(a);
+	jmp	allrght		;

+	cmp	#'i'		; case 'i':
	beq	+		;
	cmp	#'I'		; case 'I':
	beq	+		;
	cmp	#'2'		; case '2':
	bne	++		;  return slideup(a);
+	jmp	slideup		;

+	cmp	#'k'		; case 'k':
	beq	+		;
	cmp	#'K'		; case 'K':
	beq	+		;
	cmp	#'3'		; case '3':
	bne	++		;  return slidedn(a);
+	jmp	slidedn		;
	
+	cmp	#'('		; case '(':
	beq	+		;
	cmp	#'8'		; case '8':
	beq	+		;
	cmp	#'u'		; case 'u':
	beq	+		;
	cmp	#'U'		; case 'U':
	beq	+		;
	cmp	#'4'		; case '4':
	bne	++		;  return topleft(a);
+	jmp	topleft		;

+	cmp	#')'		; case ')':
	beq	+		;
	cmp	#'9'		; case '9':
	beq	+		;
	cmp	#'o'		; case 'o':
	beq	+		;
	cmp	#'O'		; case 'O':
	beq	+		;
	cmp	#'5'		; case '5':
	bne	++		;  return toprght(a);
+	jmp	toprght		;

+	cmp	#'<'		; case '<':
	beq	+		;
	cmp	#','		; case ',':
	beq	+		;
	cmp	#'j'		; case 'j':
	beq	+		;
	cmp	#'J'		; case 'J':
	beq	+		;
	cmp	#'6'		; case '6':
	bne	++		;  return botleft(a);
+	jmp	botleft		;

+	cmp	#'>'		; case '>':
	beq	+		;
	cmp	#'.'		; case '.':
	beq	+		;
	cmp	#'l'		; case 'l':
	beq	+		;
	cmp	#'L'		; case 'L':
	beq	+		;
	cmp	#'7'		; case '7':
	bne	++		;  return botrght(a);
+	jmp	botrght		; }
+	rts			;} // getmove()
