all: tmenu

tmenu: tmenu.sh
	cp tmenu.sh tmenu

install: tmenu
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	install tmenu $(DESTDIR)$(PREFIX)/bin/

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/tmenu

clean:
	rm -f tmenu

.PHONY: all install uninstall clean
