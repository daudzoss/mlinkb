NOTLINK	= 0<<6
MIDLINK = 1<<6
TOPLINK = 2<<6
BOTLINK = 3<<6

CAPTION :?= !SCREENC	; no screen color implies per-tile center caption

.if BASIC
*	= BASIC+1
.else
*	= $0002+1		; P500 loads into bank 0 but must run in bank 15
COPIED2	= $0400
	.word	(+), 3
	.text	$81,$41,$b2,$30	; FOR A = 0
	.text	$a4		; TO finish-start
	.text	format("%4d",finish-start)
	.text	$3a,$dc,$30	; : BANK 0
	.text	$3a,$42,$b2,$c2	; : B = PEEK
	.text	$28		; ( start
	.text	format("%2d",COPIED2)
	.text	$aa,$41,$29,$3a	; + A ) :
	.text	$dc,$31,$35,$3a	; BANK 1 5 :
	.text	$97		; POKE start
	.text 	format("%2d",COPIED2)
	.text	$aa,$41,$2c,$42	; + A , B
	.text	$3a,$82,0	; : NEXT
+
.endif
.if SCREENW >= $28
	.word	(+), 2052
	.text	$86,$41,$24,$28	; DIM A $ (
	.text	$32,$30,$29,$3a	; 2 0 ) :
	.text	$41,$24,$28,$31	; A $ ( 1
	.text	$29,$b2,$22	; ) = "
	.text	     " missing link is a"
	.text	$22,$3a		; " :
	.text	$41,$24,$28,$32	; A $ ( 2
	.text	$29,$b2,$22	; ) = "
	.text	     " mechanical puzzle"
	.text	$22,$3a		; " :
	.text	$41,$24,$28,$33	; A $ ( 3
	.text	$29,$b2,$22	; ) = "
	.text	     " invented in 1981 "
	.text	$22,$3a		; " :
	.text	$41,$24,$28,$34	; A $ ( 4
	.text	$29,$b2,$22	; ) = "
	.text	     " by steven p. han-"
	.text	$22,$3a		; " :
	.text	$41,$24,$28,$35	; A $ ( 5
	.text	$29,$b2,$22	; ) = "
	.text	     " son and jeffrey  "
	.text	$22,$3a		; " :
	.text	$41,$24,$28,$36	; A $ ( 6
	.text	$29,$b2,$22	; ) = "
	.text	     " d. breslow.      "
	.text	$22,0		; "
+	.word	(+), 2053
	.text	$41,$24,$28,$37	; A $ ( 7
	.text	$29,$b2,$22	; ) = "
	.text	     " the puzzle has   "
	.text	$22,$3a		; " :
	.text	$41,$24,$28,$38	; A $ ( 8
	.text	$29,$b2,$22	; ) = "
	.text	     " four sides, each "
	.text	$22,$3a		; " :
	.text	$41,$24,$28,$39	; A $ ( 9
	.text	$29,$b2,$22	; ) = "
	.text	     " depicting a chain"
	.text	$22,$3a		; " :
	.text	$41,$24,$28,$31	; A $ ( 1
	.text	$30,$29,$b2,$22	; 0 ) = "
	.text	     " of a different   "
	.text	$22,$3a		; " :
	.text	$41,$24,$28,$31	; A $ ( 1
	.text	$31,$29,$b2,$22	; 1 ) = "
	.text	     " color.  each side"
	.text	$22,$3a		; " :
	.text	$41,$24,$28,$31	; A $ ( 1
	.text	$32,$29,$b2,$22	; 2 ) = "
	.text	     " contains four    "
	.text	$22,$3a		; " :
	.text	$41,$24,$28,$31	; A $ ( 1
	.text	$33,$29,$b2,$22	; 3) = "
	.text	     " tiles, except one"
	.text	$22,0		; " :
+	.word	(+), 2054
	.text	$41,$24,$28,$31	; A $ ( 1
	.text	$34,$29,$b2,$22	; 4) = "
	.text	     " which contains   "
	.text	$22,$3a		; " :
	.text	$41,$24,$28,$31	; A $ ( 1
	.text	$35,$29,$b2,$22	; 5) = "
	.text	     " three tiles and a"
	.text	$22,$3a		; " :
	.text	$41,$24,$28,$31	; A $ ( 1
	.text	$36,$29,$b2,$22	; 6) = "
	.text	     " gap.             "
	.text	$22,$3a		; " :
	.text	$41,$24,$28,$31	; A $ ( 1
	.text	$37,$29,$b2,$22	; 7) = "
	.text	     " the two middle   "
	.text	$22,$3a		; " :
	.text	$41,$24,$28,$31	; A $ ( 1
	.text	$38,$29,$b2,$22	; 8) = "
	.text	     " rows cannot be   "
	.text	$22,$3a		; " :
	.text	$41,$24,$28,$31	; A $ ( 1
	.text	$39,$29,$b2,$22	; 9) = "
	.text	     " rotated.         "
	.text	$22,$3a		; " :
	.text	$41,$24,$28,$32	; A $ ( 2
	.text	$30,$29,$b2,$22	; 0) = "
	.text	     " - wikipedia entry"
	.text	$22,0		; "
+
.endif	
	.word	(+), 2055
	.text	$99,$22,$1f,$09	; PRINT " CHR(31) CHR$(9) // BLU,enable
	.text	$8e,$08		; CHR$(142) CHR$(8) // UPPER,disabl
.if SCREENW > $17
	.text	$13,$13		; HOME HOME // (undoes windows on C16,C128,...)
.endif
CRSRDNS :?= 0
.for d := 0, d < CRSRDNS, d += 1
	.text	$11		; CRSR_DN
.next
	.text	$13,$11		; HOME CRSR_DN
	.text	$22,$3b		; "; 
	.text	$3a,$81,$49,$b2	; : FOR I =
	.text	$30,$a4,$33,$3a	; 0 TO 3 :
	.text	$81,$4a,$b2,$31	; FOR J = 1
	.text	$a4,$35,$3a,$99	; TO 5 : PRINT
	.text	$ca,$28,$22,$cf	; MID$ ( " /
	.text	$a5,$a5,$a5,$cc	; | | | \
	.text	$22,$2c,$4a,$2c	; " , J ,
	.text	$31,$29,$3b,$a6	; 1 ) ; SPC(
	.text	$32,$30		; 2 0
	.text	$29,$3b,$ca,$28	; ) ; MID$ (
	.text	$22,$d0,$a7,$a7	; " \ | |
	.text	$a7,$ba,$22,$2c	; | / " ,
	.text	$4a,$2c,$31,$29	; J , 1 )
	.text	$3b		; ;
.if SCREENW >= $28
	.text	$41,$24,$28,$49	; A $ ( I
	.text	$ac,$35,$aa,$4a	; * 5 + J
	.text	$29		; )
.if SCREENW == $28
	.text	$3b		; ;
.endif
.endif	
	.text	$3a,$82,$3a	; : NEXT :
	.text	$82,$3a,$99,$22	; NEXT : PRINT "
	.text	$9c		; PUR
	.text	$9c,$12,"(",$92,","
	.text	$12,")",$92,"top "
	.text	$12,"<",$92,","
	.text	$12,">",$92,"bot "
	.text	$12,"i",$92,","
	.text	$12,"k",$92,"slide"
.if SCREENH > $17
.for d := $17, d < SCREENH, d += 1
	.text	$11		; CRSR_DN
.next
	.text	$22,$3a,$99,$a6	; " : print SPC(
	.text	format("%2d",SCREENW-$16)
	.text	$29,$3b,$22	; ) ; "
.endif
	.text	$1f		; BLU
	.text	"github:daudzoss/mlink"
	.text	$13,$22,$3b	; HOME ";
	.text	$3a,$9e		; : SYS main
	.null	format("%4d",main)
+	.word 0
.if !BASIC
*	= COPIED2
.endif

start
.include "checksub.asm"

.include "drawsubs.asm"

.include "movesubs.asm"

tempbot	.fill	1		;static uint8_t tempbot;
state	.byte	NOTLINK		;static uint8_t state[16] = { NOTLINK,
	.byte	TOPLINK|WHT	;                             TOPLINK|WHT,
	.byte	MIDLINK|WHT	;                             MIDLINK|WHT,
	.byte	BOTLINK|WHT	;                             BOTLINK|WHT,
	.byte	TOPLINK|RED	;                             TOPLINK|RED,
	.byte	MIDLINK|RED	;                             MIDLINK|RED,
	.byte	MIDLINK|RED	;                             MIDLINK|RED,
	.byte	BOTLINK|RED	;                             BOTLINK|RED,
	.byte	TOPLINK|YEL	;                             TOPLINK|YEL,
	.byte	MIDLINK|YEL	;                             MIDLINK|YEL,
	.byte	MIDLINK|YEL	;                             MIDLINK|YEL,
	.byte	BOTLINK|YEL	;                             BOTLINK|YEL,
	.byte	TOPLINK|GRN	;                             TOPLINK|GRN,
	.byte	MIDLINK|GRN	;                             MIDLINK|GRN,
	.byte	MIDLINK|GRN	;                             MIDLINK|GRN,
	.byte	BOTLINK|GRN	;                             BOTLINK|GRN };
temptop	.fill	1		;static uint8_t temptop;
main
.if !BASIC
	lda	#$0f		;// P500 has to start in bank 15
	sta	$01		;static volatile int execute_bank = 15;
.endif
.if	BKGRNDC
	lda	#BACKGND	;void main(void) {
	sta	BKGRNDC		; BKGRNDC = BACKGND;
.endif
	jsr	shuffle		; shuffle();
.if SCREENC
	lda	SCREENC+SCREENW*SCREENH-2
	sta	SCREENC+SCREENW*SCREENH-1
	ldy	#SCREENW	;
-	sta	SCREENC-1,y	;
	dey			;
	bne	-		;
.endif
	lda	#'b'-'@'	;
	sta	SCREENM+SCREENW*SCREENH-1
-	jsr	getmove		; do {
	jsr	drawall		;  getmove();
	jsr	checkok		;  drawall();
	beq	-		; } while (!checkok());
	rts			;}
finish
.end
