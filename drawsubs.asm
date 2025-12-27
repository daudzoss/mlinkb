.if 0
THICKTP	= 
THICKBT	= 
THICKLT	=
THICKRT	=

SYM1200	= THICKBT		; 5/8 @B
SYM1230	= ; 1/4 @BL
SYM0100	= ; 1/2 @TR
SYM0130	= ; /8 @L
SYM0200	= ; 6/8 @L
SYM0300	= ; 7/8 @R
SYM0400	= SYM0200; 6/8 @L
SYM0430	= SYM0130; /8 @L
SYM0500	= ; 1/2 @TL
SYM0530	= ; 1/4 @TL
SYM0600	= ; 5/8 @T
SYM0630	= 
SYM0700	=
SYM0730	=
.endif
dsymloc	= dsymlda + 1		;static char* dsymloc;
drawloc	= dlocsta + 1		;static char* drawloc;
attrloc	= alocsta + 1		;static char* attrloc;

symset .byte $30,$30,$30,$30,$30;static const symset[4][25] = { {
       .byte $30,$30,$30,$30,$30;
       .byte $30,$30,$30,$30,$30;
       .byte $30,$30,$30,$30,$30;
       .byte $30,$30,$30,$30,$30;
	.byte	0,0,0,0,0,0,0	;
       .byte $31,$31,$31,$31,$31;
       .byte $31,$31,$31,$31,$31;
       .byte $31,$31,$31,$31,$31;
       .byte $31,$31,$31,$31,$31;
       .byte $31,$31,$31,$31,$31;
	.byte	0,0,0,0,0,0,0	;
       .byte $32,$32,$32,$32,$32;
       .byte $32,$32,$32,$32,$32;
       .byte $32,$32,$32,$32,$32;
       .byte $32,$32,$32,$32,$32;
       .byte $32,$32,$32,$32,$32;
	.byte	0,0,0,0,0,0,0	;
       .byte $33,$33,$33,$33,$33;
       .byte $33,$33,$33,$33,$33;
       .byte $33,$33,$33,$33,$33;
       .byte $33,$33,$33,$33,$33;
       .byte $33,$33,$33,$33,$33;
	;.byte	0,0,0,0,0,0,0	;};
count5i	.fill	1		;void drawtil(register uint8_t a) {
count5j	.fill	1		; static uint8_t count5i, count5j;
attrcod	.fill	1		; static char attrcod;
drawtil	sta	attrcod		;
	lsr			;
	and	#$60		;
	clc			;
	adc	#<symset	;
	sta	dsymloc		;
	lda	#>symset	;
	adc	#0		;
	sta	1+dsymloc	; dsymloc = symset[a>>6]; // tile type 0~3,
	lda	attrcod		;
	and	#$3f		;
	sta	attrcod		; attrcod = a & 0x3f; // tile attribute (color)
	lda	#5		;
	sta	count5i		; for (count5i = 5; count5i; count5i--) {
-	lda	#5		;
	sta	count5j		;  for (count5j = 5; count5j; count5j--) {
-	lda	attrcod		;
alocsta	sta	$ffff		;   *attrloc++ = attrcod;
	inc	alocsta+1	;
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
	;clc
	adc	#<SCREENM	;
	sta	drawloc		;
	lda	#>SCREENM	;
	;adc	#0
	sta	1+drawloc	; drawloc = (char*) (SCREENM + (y / 4) * 5);
	lda	ydiv4x5		;
	;clc			;
	adc	#<SCREENC	;
	sta	attrloc		;
	lda	#>SCREENC	;
	;adc	#0
	sta	1+attrloc	; attrloc = (char*) (SCREENC + (y / 4) * 5);
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
