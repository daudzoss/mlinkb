NOTLINK	= 0<<6
MIDLINK = 1<<6
TOPLINK = 2<<6
BOTLINK = 3<<6

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
	.text	$3a,$82,$00	; : NEXT
+
.endif
	.word	(+), 2055
	.text	$99,$22,$1f,$09	; PRINT " CHR(31) CHR$(9) // BLU,enable
	.text	$8e,$08,$13,$13	; CHR$(142) CHR$(8) CHR$(19) // UPPER,disabl,clr
	.text	$93,$22,$3b	; "; (second home undoes windows on C16,C128...)
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
.if SCREENW == $16
	.text	$3b		; ;
.endif	
	.text	$3a,$82,$3a	; : NEXT :
	.text	$82,$3a,$99,$22	; NEXT : PRINT "
	.text	$9c,$12,"(",$92,","
	.text	$12,")",$92,"top "
	.text	$12,"<",$92,","
	.text	$12,">",$92,"bot "
	.text	$12,"i",$92,","
	.text	$12,"k",$92,"slide"
.if SCREENW != $16
	.text	$0d,$0d
.endif
	.text	$1f,"github:"
	.text	"daudzoss/mlin5k"
	.text	$22,$3b		; ";
	.text	$3a,$9e		; : SYS main
	.null	format("%4d",main)
+	.word 0
.if !BASIC
*	= COPIED2
.endif

start
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
	lda	#BACKGND	;void main(void) [
	sta	BKGRNDC		; BKGRNDC = BACKGND;
-	jsr	drawall		; do { drawall();
	jsr	getmove		; getmove(); } while (1);
	jmp	-		;}

finish
.end
