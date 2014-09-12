# This is pretty dangerous in a bunch of ways.  Approach with caution.
DESTDIR=/afs/athena.mit.edu/system/athena10/installer/$(SUITE)

# You only want to change these if testing something.
SERVERIP=18.9.60.73
SUITE=stage1

# Where, within the tarball, the binaries go.
LIBEXECDIR=debathena/lib

default:
	: Use "make install" to move this from where the installer will fetch it.

install: $(DESTDIR) $(DESTDIR)/debathena.tar.gz

$(DESTDIR):
	$(error $(DESTDIR) does not exist)

host.amd64 host.i386: host/host.c
	gcc $(if $(subst .amd64,,$(suffix $@)),-m32,-m64) -static $< -lcares -o $@

$(LIBEXECDIR): host.amd64 host.i386 kexec/kexec
	mkdir -p $@
	install -m 755 $^ $@

debathena.preseed:
	@echo "d-i preseed/include_command string wget -q http://$(SERVERIP)/installer/$(SUITE)/debathena-loader.sh ; sh debathena-loader.sh" > $@

$(DESTDIR)/debathena.tar.gz: debathena.preseed debathena-loader.sh debathena $(LIBEXECDIR)
	test -w "$(DESTDIR)"
	git rev-parse --short HEAD > debathena/version
	tar czvf $(DESTDIR)/debathena.tar.gz --exclude "*~" debathena
	cp debathena.preseed debathena-loader.sh $(DESTDIR)
	rm debathena/version
	rm -f host.amd64 host.i386
	rm -f debathena.preseed
	rm -rf $(LIBEXECDIR)

clean:
	rm -rf $(LIBEXECDIR)
	rm -f debathena.preseed
	rm -f host.amd64 host.i386

.PHONY: clean install debathena.preseed
