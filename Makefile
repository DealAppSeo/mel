# Mel Plugin Makefile
CC = gcc
CFLAGS = $(shell pkg-config --cflags geany gtk+-3.0 sqlite3 json-c) -fPIC -Wall -O2
LDFLAGS = $(shell pkg-config --libs geany gtk+-3.0 sqlite3 json-c libcurl) -shared

SOURCES = $(wildcard src/*.c)
OBJECTS = $(SOURCES:.c=.o)
TARGET = mel.so

PREFIX ?= /usr/local
PLUGIN_DIR = $(PREFIX)/lib/geany

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -o $@ $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET)

install: $(TARGET)
	install -D $(TARGET) $(DESTDIR)$(PLUGIN_DIR)/mel.so
	install -D -m 644 config/default_config.json $(DESTDIR)/etc/mel/config.json

install-user: $(TARGET)
	install -D $(TARGET) ~/.config/geany/plugins/mel.so
	mkdir -p ~/.config/mel
	cp config/default_config.json ~/.config/mel/config.json

uninstall:
	rm -f $(DESTDIR)$(PLUGIN_DIR)/mel.so
	rm -rf $(DESTDIR)/etc/mel

.PHONY: all clean install install-user uninstall