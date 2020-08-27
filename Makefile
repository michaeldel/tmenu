all: tmenu

tmenu: tmenu.sh
	cp tmenu.sh bin/tmenu

install: tmenu
	mkdir -p $(DESDIR)$(PREFIX)/bin
	install bin/tmenu $(DESTDIR)$(PREFIX)/bin/

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/tmenu

clean:
	rm -f tmenu

.PHONY: all install uninstall clean
