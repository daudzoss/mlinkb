all : mlinkb_40col.prg mlinkb_p80.prg mlinkb_vic20.prg mlinkb_p500.prg mlinkb_c64.prg mlinkb_c16.prg

mlinkb_40col.prg : main.asm checksub.asm drawsubs.asm movesubs.asm pet/40col.inc
	64tass -a -DADDLKEY:=1 pet/40col.inc main.asm -L mlinkb_40col.lst -o mlinkb_40col.prg

mlinkb_vic20.prg : main.asm checksub.asm drawsubs.asm movesubs.asm vic20/header.inc
	64tass -a vic20/header.inc main.asm -L mlinkb_vic20.lst -o mlinkb_vic20.prg

mlinkb_p500.prg : main.asm checksub.asm drawsubs.asm movesubs.asm p500/header.inc
	64tass -a p500/header.inc main.asm -L mlinkb_p500.lst -o mlinkb_p500.prg

mlinkb_c64.prg : main.asm checksub.asm drawsubs.asm movesubs.asm c64/header.inc
	64tass -a -DADDLKEY:=1 c64/header.inc main.asm -L mlinkb_c64.lst -o mlinkb_c64.prg

mlinkb_c16.prg : main.asm checksub.asm drawsubs.asm movesubs.asm c16/header.inc
	64tass -a -DADDLKEY:=1 c16/header.inc main.asm -L mlinkb_c16.lst -o mlinkb_c16.prg

clean :
	rm -f *.prg *.lst
