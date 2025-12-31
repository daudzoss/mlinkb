ADDLKEY	:?= 0
	
missing	.byte	0		;static int4_t missing = 0;
randnum	.byte	$55		;statig int8_t randnum = 0xbf;
jumpto0	.word	allleft		;static uint8_t (*jumpto)(void)[8] = { allleft,
jumpto1	.word	allrght		;                                      allrght,
jumpto2	.word	slideup		;                                      slideup,
jumpto3	.word	slidedn		;                                      slidedn,
jumpto4	.word	topleft		;                                      topleft,
jumpto5	.word	toprght		;                                      toprght,
jumpto6	.word	botleft		;                                      botleft,
jumpto7	.word	botrght		;                                      botrght};

rndmove	lda	RNDLOC1		;uint8_t rndmove(void) {
	eor	RNDLOC2		;
	asl			;
	eor	randnum		;
	sta	randnum		;
	lsr			;
	lsr			;
	lsr			;
	eor	randnum		;
	and	#$0e		;
	sta	randnum		;
	tay			; register uint3_t y = rand(8);
	lda	jumpto0,y	;
	sta	jumpvec+1	;
	lda	jumpto0+1,y	; jumpvec = jumpto[y];
	sta	jumpvec+2	; return (*jumpvec)();
jumpvec	jmp	$ffff		;} // rndmove()

shuffle	ldy	#<$100		;void shuffle(void) {
-	dey			; for (auto uint9_t y = 256; y; y--) {
	tya			;
	pha			;
	jsr	rndmove		;  rndmove();
	jsr	drawall		;  drawall();
	jsr	$ffe4		;
	beq	+		;  if (/*key pressed*/) {
	pla			;
	lda	#0		;   break;
	pha			;  }
+	pla			;
	tay			;
	bne	-		; }
	rts			;} // shuffle()
	
.if ADDLKEY
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
	and	#$0f		;
	sta	missing		; return missing = (missing - 1) & 0x0f;
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
	and	#$0f		;
	sta	missing		; return missing = (missing + 1) & 0x0f;
	rts			;} // upby1()
.endif

allleft
.if ADDLKEY
	jsr	downby1		;uint4_t allleft(void) { register uint4_t a;
	jsr	downby1		; for (int unrolled = 4; unrolled; unrolled--)
	jsr	downby1		;  a = downby1();
	jsr	downby1		; return a; // new value of missing
.endif
	rts			;} // alleft()

allrght
.if ADDLKEY
	jsr	upby1		;uint4_t allrght(void) { register uint4_t a;
	jsr	upby1		; for (int unrolled = 4; unrolled; unrolled--)
	jsr	upby1		;  a = upby1();
	jsr	upby1		; return a; // new value of missing
.endif
	rts			;} // allrght()

rowmask	.byte	$03		;static const uint8_t rowmask = 0x03;

slideup	lda	missing		;uint4_t slideup(void) {
	tay			; register uint8_t y = missing; // old value
	and	#$03;rowmask	;
	cmp	#$03		;
	beq	+		; if (missing & rowmask != 3) {
	inc	missing		;  missing += 1;
	lda	state+1,y	;
	sta	state,y		;  state[y] = state[missing];
	lda	#NOTLINK	;  state[missing] = NOTLINK;
	sta	state+1,y	; }
+	lda	missing		; return missing;
	rts			;} // slideup()
slidedn	lda	missing		;uint4_t slidedn(void) {
	tay			; register uint8_t y = missing; // old value
	bit	rowmask		;
	beq	+		; if (missing & rowmask != 0) {
	dec	missing		;  missing -= 1;
	lda	state-1,y	;
	sta	state,y		;  state[y] = state[missing];
	lda	#NOTLINK	;  state[missing] = NOTLINK;
	sta	state-1,y	; }
+	lda	missing		; return missing;
	rts			;} // slidedn()

topleft	lda	state+0		;uint4_t topleft(void) {
	pha			; uint8_t temp = state[0];
	lda	state+4		;
	sta	state+0		; state[0] = state[4];
	lda	state+8		;
	sta	state+4		; state[4] = state[8];
	lda	state+$c	;
	sta	state+8		; state[8] = state[12];
	pla			;
	sta	state+$c	; state[12] = temp;
	lda	missing		;
	bit	rowmask		;
	bne	+		; if (missing & rowmask == 0) {// missing in top
;;; codedupl
	clc			;   missing -= 4;
	adc	#$fc		;   missing &= 0x0f; // 0xfc becomes 0x0c
	and	#$0f		; }
	sta	missing		; return missing;
;;; codedupl
+	rts			;} // topleft()
toprght	lda	state+$c	;uint4_t toprght(void) {
	pha			; uint8_t temp = state[12];
	lda	state+8		;
	sta	state+$c	; state[12] = state[8];
	lda	state+4		;
	sta	state+8		; state[8] = state[4];
	lda	state+0		;
	sta	state+4		; state[4] = state[0];
	pla			;
	sta	state+0		; state[0] = temp;
	lda	missing		;
	bit	rowmask		;
	bne	+		; if (missing & rowmask == 0) {// missing in top
;;; codedupl
	clc			;  missing += 4;
	adc	#4		;  missing &= 0x0f; // 0x13 becomes 0x03
	and	#$0f		; }
	sta	missing		; return missing;
;;; codedupl
+	rts			;} // topright()
botleft	lda	state+3		;uint4_t botleft(void) {
	pha			; uint8_t temp = state[3];
	lda	state+7		;
	sta	state+3		; state[3] = state[7];
	lda	state+$b	;
	sta	state+7		; state[7] = state[11];
	lda	state+$f	;
	sta	state+$b	; state[11] = state[15];
	pla			;
	sta	state+$f	; state[15] = temp;
	lda	missing		;
	and	#3;rowmask	;
	cmp	#3;rowmask	;
	bne	+		; if (missing & rowmask == 3) {// missing in bot
	lda	missing		;
;;; codedupl
	clc			;  missing -= 4;
	adc	#$fc		;  missing &= 0x0f; // 0xff becomes 0x0f
	and	#$0f		; }
	sta	missing		; return missing;
;;; codedupl
+	rts			;} // botleft()
botrght	lda	state+$f	;uint4_t botrght(void) {
	pha			; uint8_t temp = state[15];
	lda	state+$b	;
	sta	state+$f	; state[15] = state[11];
	lda	state+7		;
	sta	state+$b	; state[11] = state[7];
	lda	state+3		;
	sta	state+7		; state[7] = state[3];
	pla			;
	sta	state+3		; state[3] = temp;
	lda	missing		;
	and	#3		;
	cmp	#3		;
	bne	+		; if (missing & rowmask == 3) {// missing in bot
	lda	missing		;
;;; codedupl
	clc			;  missing += 4;
	adc	#4		;  missing &= 0x0f;
	and	#$0f		; }
	sta	missing		; return missing;
;;; codedupl
+	rts			;} // botrght()

getmove	jsr	$ffe4		;int8_t getmove(void) {
	beq	getmove		; switch (register char a = getchar()) {

.if ADDLKEY
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
.else
	and	#$ef		;
.endif

+	cmp	#'i'		; case 'i':
.if ADDLKEY
	beq	+		;
	cmp	#'I'		; case 'I':
	beq	+		;
	cmp	#'w'		; case 'w':
	beq	+		;
	cmp	#'W'		; case 'W':
	beq	+		;
	cmp	#$91		; case CRSR_UP:
	beq	+		;
	cmp	#'2'		; case '2':
.endif
	bne	++		;  return slideup(a);
+	jmp	slideup		;

+	cmp	#'k'		; case 'k':
.if ADDLKEY
	beq	+		;
	cmp	#'K'		; case 'K':
	beq	+		;
	cmp	#'s'		; case 's':
	beq	+		;
	cmp	#'S'		; case 'S':
	beq	+		;
	cmp	#$11		; case CRSR_DN:
	beq	+		;
	cmp	#'3'		; case '3':
.endif
	bne	++		;  return slidedn(a);
+	jmp	slidedn		;
	
+	cmp	#'('		; case '(':
.if ADDLKEY
	beq	+		;
	cmp	#'8'		; case '8':
	beq	+		;
	cmp	#'u'		; case 'u':
	beq	+		;
	cmp	#'U'		; case 'U':
	beq	+		;
	cmp	#'q'		; case 'q':
	beq	+		;
	cmp	#'Q'		; case 'Q':
	beq	+		;
	cmp	#'4'		; case '4':
.endif
	bne	++		;  return topleft(a);
+	jmp	topleft		;

+	cmp	#')'		; case ')':
.if ADDLKEY
	beq	+		;
	cmp	#'9'		; case '9':
	beq	+		;
	cmp	#'o'		; case 'o':
	beq	+		;
	cmp	#'O'		; case 'O':
	beq	+		;
	cmp	#'e'		; case 'e':
	beq	+		;
	cmp	#'E'		; case 'E':
	beq	+		;
	cmp	#'5'		; case '5':
.endif
	bne	++		;  return toprght(a);
+	jmp	toprght		;

+	cmp	#','		; case ',':
.if ADDLKEY
	beq	+		;
	cmp	#'<'		; case '<':
	beq	+		;
	cmp	#'j'		; case 'j':
	beq	+		;
	cmp	#'J'		; case 'J':
	beq	+		;
	cmp	#'a'		; case 'a':
	beq	+		;
	cmp	#'A'		; case 'A':
	beq	+		;
	cmp	#$9d		; case CRSR_LF:
	beq	+		;
	cmp	#'6'		; case '6':
.endif
	bne	++		;  return botleft(a);
+	jmp	botleft		;

+	cmp	#'.'		; case '.':
.if ADDLKEY
	beq	+		;
	cmp	#'>'		; case '>':
	beq	+		;
	cmp	#'l'		; case 'l':
	beq	+		;
	cmp	#'L'		; case 'L':
	beq	+		;
	cmp	#'d'		; case 'd':
	beq	+		;
	cmp	#'D'		; case 'D':
	beq	+		;
	cmp	#$1d		; case CRSR_RT:
	beq	+		;
	cmp	#'7'		; case '7':
.endif
	bne	++		;  return botrght(a);
+	jmp	botrght		; }
+	lda	#$ff		; return -1;
	rts			;} // getmove()
