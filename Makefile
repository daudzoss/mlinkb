all : mlin5k_vic20.prg mlin5k_p500.prg mlin5k_c64.prg mlin5k_c16.prg

mlin5k_vic20.prg : main.asm drawsubs.asm vic20/header.inc
	64tass -a vic20/header.inc main.asm -L mlin5k_vic20.lst -o mlin5k_vic20.prg

mlin5k_p500.prg : main.asm drawsubs.asm p500/header.inc
	64tass -a p500/header.inc main.asm -L mlin5k_p500.lst -o mlin5k_p500.prg

mlin5k_c64.prg : main.asm drawsubs.asm c64/header.inc
	64tass -a c64/header.inc main.asm -L mlin5k_c64.lst -o mlin5k_c64.prg

mlin5k_c16.prg : main.asm drawsubs.asm c16/header.inc
	64tass -a c16/header.inc main.asm -L mlin5k_c16.lst -o mlin5k_c16.prg

clean :
	rm -f *.prg *.lst


