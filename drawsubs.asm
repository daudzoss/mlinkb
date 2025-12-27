
THICKTP
THICKBT
THICKLT	
THICKRT

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

drawall	ldy	#0		;void drawall(void) { // redraw entire state
dnxtcol	jsr	drawcol		; for (register uint8_t y = 0; y < 16; y++) {
	cpy	#$10		;  drawcol(y);
	bcc	dnxtcol		; }
	rts			;} // drawall()

dsymloc	= dsymlda + 1		;static char* dsymloc;
drawloc = dlocsta + 1		;static char* drawloc;
attrloc = alocsta + 1		;static char* attrloc;

count5i	.byte			;void drawtil(register uint8_t a) {
count5j	.byte			; static uint8_t count5i, count5j;
symsets	.byte (32*4) ; static const symsets[4][25] = { {
drawcod	.byte			;
drawtil	sta	drawcod		; static char drawcod = a;
	lsr			;
	and	#$60		;
	clc			;
	adc	#<symsets	;
	sta	dsymloc		;
	lda	#>symsets	;
	adc	#0		;
	sta	1+dsymloc	; dsymloc = symsets[a>>6]; // tile type 0~3,
	lda	drawcod		;
	and	#$3f		;
	sta	drawcod		; drawcod = a & 0x3f; // tile attribute (color)
	lda	#5		;
	sta	count5i		; for (count5i = 5; count5i; count5i--) {
-	lda	#5		;
	sta	count5j		;  for (count5j = 5; count5j; count5j--) {
-	lda	drawcod		;
alocsta	sta	$ffff		;   *attrloc++ = drawcod;
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
	lda	dlocsta+2	;
	adc	#0		;
	sta	dlocsta+2	;  drawloc += SCREENW - 5; // next row on screen
	dec	count5i		;
	bne	--		; }
	rts			;} // drawtil()
	
ydiv4x5	.byte			;extern uint8_t state[16];
drawcol	lda	#<SCREENM	;void drawcol(register uint8_t y) { // 0|4|8|12
	sta	drawloc		;
	lda	#>SCREENM	;
	sta	1+drawloc	; drawloc = (char*) SCREENM;
	lda	#<COLORM	;
	sta	attrloc		;
	lda	#>COLORM	;
	sta	1+attrloc	; attrloc = (char*) COLORM;
	tya			;
	and	#$0c		;
	sta	ydiv4x5		;
	lsr			;
	lsr			;
	clc			;
	adc	ydiv4x5		;
	sta	ydiv4x5		; static ydiv4x5 = (y / 4) * 5;
	adc	drawloc		;
	sta	drawloc		; drawloc += ydiv4x5; // screen col 0|5|10|15
	;lda	1+drawloc
	;adc	#0
	;sta	1+drawloc
	lda	ydiv4x5		;
	clc			;
	adc	attrloc		;
	sta	attrloc		; attrloc += ydiv4x5; // color col 0|5|10|15
	;lda	1+attrloc
	;adc	#0
	;sta	1+attrloc
dnxtrow	lda	state,y		; do {
	jsr	drawtil		;  drawtil(register uint8_t a = state[y]);
	iny			;
	tya			;
	and	#$03		;
	bne	dnxtrow		; } while (++y & 0x03); // end of column
	rts			;} // drawcol()

