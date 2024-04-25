NAME=tetrix
DATA_FILES=info.json
COMP=xz
RIVEMU_RUN=rivemu
RIVEMU_EXEC=rivemu -quiet -no-window -sdk -workspace -exec
ifneq (,$(wildcard /usr/sbin/riv-run))
	RIVEMU_RUN=riv-run
	RIVEMU_EXEC=
endif
CFLAGS=$(shell $(RIVEMU_EXEC) riv-opt-flags -Ospeed)

build: $(NAME).sqfs

run: $(NAME).sqfs
	$(RIVEMU_RUN) $<

clean:
	rm -f *.sqfs *.elf *.c

$(NAME).sqfs: $(NAME).elf $(DATA_FILES)
	$(RIVEMU_EXEC) riv-mksqfs $^ $@ -comp $(COMP)

$(NAME).elf: $(NAME).nelua *.nelua
	$(RIVEMU_EXEC) nelua --verbose --release --binary --cache-dir=. --cflags="$(CFLAGS)" --output=$@ $<
	$(RIVEMU_EXEC) riv-strip $@
