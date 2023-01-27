# Makefile for makeup/remake

SHELL=/bin/bash

# See https://stackoverflow.com/a/73509979/237059
RemakeHome := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

RemakeVer=4.3

.PHONY: nope
nope:
	@# TODO: explain nope

.PHONY: checkdir
checkdir:
	@[[ $(PWD) == $(RemakeHome) ]] || exit "1 Must run in $(RemakeHome) as current dir"


download: checkdir
	mkdir download

download/remake-4.3.deb: download
	cd download && \
		curl -L http://mirrors.kernel.org/ubuntu/pool/universe/r/remake/remake_$(RemakeVer)+dbg-1.5+dfsg-1_amd64.deb -o remake_$(RemakeVer).deb

.PHONY: install-remake-4.3
install-remake-4.3: download/remake-$(RemakeVer).deb
	@-sudo apt-get remove -y remake;
	sudo apt-get install -y remake
	sudo apt-get install -y --only-upgrade ./download/remake_4.3.deb

