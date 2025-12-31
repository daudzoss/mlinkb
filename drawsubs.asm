INV	= $80
THINTP	= $63
THINBT	= $64
THINLT	= $65
THINRT	= $67
THICKTP	= $77
THICKBT	= $6f
THICKLT	= $74
THICKRT	= $6a
POINTTL	= $69
POINTTR	= $5f	
POINTBL	= INV|POINTTR
POINTBR	= INV|POINTTL
CORNRTL	= $7e
CORNRTR	= $7c
CORNRBL	= $7b
CORNRBR	= $6c

SYM1200	= INV|THICKTP
SYM1230	= CORNRBL
SYM0100	= POINTTR
SYM0130	= CORNRBL
SYM0200	= INV|THICKRT
SYM0300	= INV|THINLT
SYM0400	= SYM0200
SYM0430	= CORNRTL
SYM0500	= POINTBR
SYM0530	= CORNRTL
SYM0600	= INV|THICKBT
SYM0630	= CORNRTR
SYM0700	= POINTBL
SYM0730	= CORNRTR
SYM0800	= INV|THICKLT	
SYM0900	= INV|THINRT
SYM1000	= SYM0800
SYM1030 = CORNRBR
SYM1100	= POINTTL
SYM1130	= CORNRBR	

dsymloc	= dsymlda + 1		;static char* dsymloc;
drawloc	= dlocsta + 1		;static char* drawloc;
attrloc	= alocsta + 1		;static char* attrloc;


bit5h
symset .byte $20,$20,$20,$20,$20;static const symset[4][25] = { {
       .byte $20,$20,$20,$20,$20;
       .byte $20,$20,$20,$20,$20;
       .byte $20,$20,$20,$20,$20;
       .byte $20,$20,$20,$20,$20;
	.byte	0,0,0,0,0,0,0	;


	.byte	SYM0900,$20,$20	;
	.byte	$20,SYM0300	;
	
	.byte	SYM0800,SYM1130	;
	.byte	SYM1200,SYM1230	;
	.byte	SYM0400		;
	
	.byte	SYM1030,SYM1100	;
	.byte	$20,SYM0500	;
	.byte	SYM0430		;

	.byte	SYM1000,SYM0630	;
	.byte	SYM0600,SYM0530	;
	.byte	SYM0200		;

	.byte	SYM0900,$20,$20	;
	.byte	$20,SYM0300	;
	.byte	0,0,0,0,0,0,0	;
	

	.byte	$20,$20,$20,$20	;
	.byte	$20		;

	.byte	$20,SYM1130	;
	.byte	SYM1200,SYM1230	;
	.byte	$20		;

	.byte	SYM1030,SYM1100	;
	.byte	$20,SYM0100	;
	.byte	SYM0130		;

	.byte	SYM1000,$20,$20	;
	.byte	$20,SYM0200	;

	.byte	SYM0900,$20,$20	;
	.byte	$20,SYM0300	;
	.byte	0,0,0,0,0,0,0	;
	

	.byte	SYM0900,$20,$20	;
	.byte	$20,SYM0300	;

	.byte	SYM0800,$20,$20	;
	.byte	$20,SYM0400	;

	.byte	SYM0730,SYM0700	;
	.byte	$20,SYM0500	;
	.byte	SYM0430		;

	.byte	$20,SYM0630	;
	.byte	SYM0600,SYM0530	;
	.byte	$20

	.byte	$20,$20,$20,$20	;
	.byte	$20
	;.byte	0,0,0,0,0,0,0	;};
count5i	.fill	1		;void drawtil(register uint8_t a) {
count5j	.fill	1		; static uint8_t count5i, count5j;
attrcod	.fill	1		; static char attrcod;
bits76h	= 	drawtil+4	;
drawtil	sta	attrcod		;
	and	#$c0		; static const norzset = 0xc0;
	lsr			;
	clc			;
	adc	#<symset	;
	sta	dsymloc		;
	lda	#>symset	;
	adc	#0		;
	sta	1+dsymloc	; dsymloc = symset[a>>6]; // tile type 0~3,
	lda	#5		;
	sta	count5i		; for (count5i = 5; count5i; count5i--) {
-	lda	#5		;
	sta	count5j		;  for (count5j = 5; count5j; count5j--) {
-	lda	attrcod		;
	bit	bits76h		;
	beq	+		;   if (attrcod & 0xc0) { // not a MISSING tile
	and	#$3f		;    attrcod &= 0x3f; // just the color in low 6
	bit	bit5h		;
	beq	alocsta		;    if (attrcod & 0x20) // for c16, move bit 6
	eor	#$60		;     attrcod ^= 0x60; // into bit 7 for clarity
alocsta	sta	$ffff		;    *attrloc++ = attrcod; // do tile foreground
+	inc	alocsta+1	;   }
	bne	dsymlda		;
	inc	alocsta+2	;
dsymlda	lda	$ffff		;
	inc	dsymlda+1	;
	bne	dlocsta		;
	inc	dsymlda+2	;
dlocsta	sta	$ffff		;   *drawloc++ = *dsymloc++;
	inc	dlocsta+1	;
	bne	+		;
	inc	dlocsta+2	;
+	dec	count5j		;
	bne	-		;  }
	lda	#SCREENW - 5	;
	clc			;
	adc	alocsta+1	;
	sta	alocsta+1	;
	lda	alocsta+2	;
	adc	#0		;
	sta	alocsta+2	;  attrloc += SCREENW - 5;
	lda	#SCREENW - 5	;
	clc			;
	adc	dlocsta+1	;
	sta	dlocsta+1	;
	lda	dlocsta+2	;
	adc	#0		;
	sta	dlocsta+2	;  drawloc += SCREENW - 5; // next row on screen
	dec	count5i		;
	bne	--		; }
	rts			;} // drawtil()

ydiv4x5	.fill	1		;extern uint8_t state[16];
drawcol	tya			;void drawcol(register uint8_t& y) { // 0|4|8|12
	and	#$0c		;
	sta	ydiv4x5		;
	lsr			;
	lsr			;
	clc			;
	adc	ydiv4x5		;
	sta	ydiv4x5		; static uint8_t ydiv4x5 = (y/4)*5; // 0|5|10|15
	sec			;
	adc	#<(SCREENM+SCREENW);
	sta	drawloc		;
	lda	#>SCREENM	;
	;adc	#0
	sta	1+drawloc	; drawloc = (char*) (SCREENM+SCREENW+1+(y/4)*5);
	lda	ydiv4x5		;
	sec			;
	adc	#<(SCREENC+SCREENW);
	sta	attrloc		;
	lda	#>SCREENC	;
	;adc	#0
	sta	1+attrloc	; attrloc = (char*) (SCREENC+SCREENW+1+(y/4)*5);
-	lda	state,y		; do {
	jsr	drawtil		;  register uint8_t a = state[y]);
	iny			;  drawtil(a);
	tya			;
	and	#$03		;
	bne	-		; } while (++y & 0x03); // y @top of next column
	rts			;} // drawcol()

drawall	ldy	#0		;void drawall(void) { // redraw whole game state
-	jsr	drawcol		; register uint5_t y = 0;
	cpy	#$10		; while (y <= 15)
	bcc	-		;  drawcol(y);
	rts			;} // drawall()
