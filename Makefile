name = putty
version = 0.76
src = $(name)-src-$(version).zip
rel = $(name)-$(version).zip
patches := desktops.patch

all: release

$(src):
	curl -o $@ -L -s https://the.earth.li/%7Esgtatham/putty/$(version)/putty-src.zip

unpack: .unpack
.unpack: $(src)
	unzip -d $(name)-src $(src)
	@touch $@

patch: .patch
.patch: .unpack $(patches)
	cat $(patches) | patch -p1 -d $(name)-src
	@touch .patch

build: .build
.build: .patch
	make -C putty-src/windows -f Makefile.mgw
	@touch $@

release: $(rel)
$(rel):
	7z a $@ ./putty-src/windows/{pageant,plink,pscp,psftp,psocks,putty,puttygen,puttytel}.exe

clean:
	-make -C putty-src/windows -f Makefile.mgw clean

distclean: clean
	-rm -f $(name)-src $(src) $(rel) .[^.]*

.PHONY: all release unpack patch build release clean distclean
