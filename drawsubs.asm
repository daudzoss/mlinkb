drawall	ldy	#0		;void drawall(void) { // redraw entire state
dnxtcol	jsr	drawcol		; for (register uint8_t y = 0; y < 16; y++) {
	cpy	#$10		;  drawcol(y);
	bcc	dnxtcol		; }
	rts			;} // drawall()

drawcod	.byte			;static char drawcod;
attrcod	.byte			;static char attrcod;
	
drawcol	lda	#<SCREENM	;extern uint8_t state[16];
	sta	drawloc		;void drawcol(uint8_t y) { // state col 0|4|8|12
	lda	#>SCREENM	;
	sta	1+drawloc	; drawloc = (char*) SCREENM;
	lda	#<COLORM	;
	sta	attrloc		;
	lda	#>COLORM	;
	sta	1+attrloc	; attrloc = (char*) COLORM;
	tya			;
	and	#$0c		;
	sta	drawcod		;
	lsr			;
	lsr			;
	clc			;
	adc	drawcod		;
	sta	drawcod		;
	adc	drawloc		;
	sta	drawloc		; drawloc += 5 * (y/4); // screen col 0|5|10|15
	lda	drawcod		;
	clc			;
	adc	attrloc		;
	sta	attrloc		; attrloc += 5 * (y/4); // color col 0|5|10|15
dnxtrow	lda	state,y		; do {
	jsr	drawtil		;  drawtil(register uint8_t a = state[y]);
	iny			;
	tya			;
	and	#$03		;
	bne	dnxtrow		; } while (++y & 0x03); // end of column
	rts			;} // drawcol()


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


drawloc = dlocsta + 1		;static char* drawloc;
attrloc = alocsta + 1		;static char* attrloc;
dcount5	.byte			;void drawtil(register uint8_t a) {
drawtil	sta	drawcod		; drawcod = a;
	lda	#5		;
	sta	dcount5		; for (uint8_t dcount5 = 5; dcount5; dcount--) {
	lda	drawcod		;
	and	#$3f		;
alocsta	sta	$ffff		;  *attrloc++ = drawcod & 0x3f;
	inc	alocsta+1	;
	bne	+		;
	inc	alocsta+2	;
+	bit	drawcod		;
	rts			;} // drawtil()
