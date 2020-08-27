bin/tmenu: bin tmenu.sh
	cp tmenu.sh bin/tmenu

bin:
	mkdir bin

install: bin/tmenu
	mkdir -p $(DESDIR)$(PREFIX)/bin
	install bin/tmenu $(DESTDIR)$(PREFIX)/bin/

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/tmenu

clean:
	rm -r bin

.PHONY: install uninstall clean
