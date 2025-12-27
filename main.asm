MISSING	= 0<<6
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
	.text	$8e,$08,$13	; CHR$(142) CHR$(8) CHR$(19) // UPPER,disabl,clr
	.text	$13		; second home undoes windows on C16, C128....
topline	.text	$12,"(",$92,","
	.text	$12,")",$92,"top "
	.text	$12,"<",$92,","
	.text	$12,">",$92,"bot "
	.text	$12,"i",$92,","
	.text	$12,"k",$92,"slide"
.if SCREENW >= $27
	.text	" daudzoss/mlin5k"
.endif
	.text	$22		; "
	.text	$3a,$9e		; : SYS main
	.null	format("%4d",main)
+	.word 0
.if !BASIC
*	= COPIED2
.endif

start
.include "drawsubs.asm"
state	.byte	0
	.byte	TOPLINK|WHT
	.byte	MIDLINK|WHT
	.byte	BOTLINK|WHT
	.byte	TOPLINK|RED
	.byte	MIDLINK|RED
	.byte	TOPLINK|RED
	.byte	MIDLINK|RED
	.byte	TOPLINK|RED
	.byte	MIDLINK|RED
	.byte	TOPLINK|RED
	.byte	MIDLINK|RED
	.byte	TOPLINK|RED
	.byte	MIDLINK|RED
	.byte	TOPLINK|RED
	.byte	MIDLINK|RED
main
.if !BASIC
	lda	#$0f		;// P500 has to start in bank 15
	sta	$01		;static volatile int execute_bank = 15;
.endif
	lda	#BACKGND	;void main(void) [
	sta	BKGRNDC		; BKGRNDC = BACKGND
 jmp drawall
finish
.end
