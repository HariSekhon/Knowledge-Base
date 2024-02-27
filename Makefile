#
#  Author: Hari Sekhon
#  Date: 2016-01-17 12:56:53 +0000 (Sun, 17 Jan 2016)
#
#  vim:ts=4:sts=4:sw=4:noet
#
#  https://github.com/HariSekhon/Docs
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback
#
#  https://www.linkedin.com/in/HariSekhon
#

ifneq ("$(wildcard bash-tools/Makefile.in)", "")
	include bash-tools/Makefile.in
endif

REPO := HariSekhon/Docs

CODE_FILES := $(shell git ls-files | grep -E -e '\.md$$' | sort)

.PHONY: build
build: init
	@echo ================
	@echo Docs Builds
	@echo ================
	@echo
	@#$(MAKE) git-summary
	mdl *.md

.PHONY: init
init:
	@echo
	@echo "running init:"
	git submodule update --init --recursive
	@echo

.PHONY: install
install: build
	@:

.PHONY: test
test:
	bash-tools/checks/check_all.sh

.PHONY: clean
clean:
	@rm -fv -- *.pyc *.pyo
