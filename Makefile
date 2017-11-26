VERSION=0.1.1
CC=cc
INSTALL=install
CFLAGS=$(shell pkg-config --cflags sqlite3 libpcre) -fPIC
LIBS=$(shell pkg-config --libs libpcre)
prefix=/usr

.PHONY : install dist clean
OS := $(shell uname)

pcre.so : pcre.c
ifeq ($(OS),Linux)
	${CC} -shared -o $@ ${CFLAGS} -W -Werror pcre.c ${LIBS} -Wl,-z,defs
else
	${CC} -shared -o $@ ${CFLAGS} -W -Werror pcre.c ${LIBS} -lpcre
endif
install : pcre.so
	${INSTALL} -pD -m755 pcre.so ${DESTDIR}${prefix}/lib/sqlite3/pcre.so

dist : clean
	mkdir sqlite3-pcre-${VERSION}
	cp -f pcre.c Makefile readme.txt sqlite3-pcre-${VERSION}
	tar -czf sqlite3-pcre-${VERSION}.tar.gz sqlite3-pcre-${VERSION}

clean :
	-rm -f pcre.so
