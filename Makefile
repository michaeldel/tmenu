bin/tmenu: bin tmenu.sh
	cp tmenu.sh bin/tmenu

bin:
	mkdir bin

.PHONY: clean
clean:
	rm -r bin

