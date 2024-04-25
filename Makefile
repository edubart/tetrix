NAME=tetrix
DATA_FILES=info.json
COMP=xz
RIVEMU=rivemu
RIVEMU_EXEC=$(RIVEMU) -quiet -no-window -sdk -workspace -exec
CFLAGS=$(shell $(RIVEMU_EXEC) riv-opt-flags -Ospeed)

build: $(NAME).sqfs

run: $(NAME).sqfs
	$(RIVEMU) $<

clean:
	rm -f *.sqfs *.elf *.c

$(NAME).sqfs: $(NAME).elf $(DATA_FILES)
	$(RIVEMU_EXEC) riv-mksqfs $^ $@ -comp $(COMP)

$(NAME).elf: $(NAME).nelua *.nelua
	$(RIVEMU_EXEC) nelua --verbose --release --binary --cache-dir=. --cflags="$(CFLAGS)" --output=$@ $<
	$(RIVEMU_EXEC) riv-strip $@
