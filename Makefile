PREFIX=/usr/local
BINDIR=$(PREFIX)/bin

install: install-python-project

install-python-project:
	install -m 755 python-project.sh $(BINDIR)/python-project