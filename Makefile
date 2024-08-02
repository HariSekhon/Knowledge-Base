#
#  Author: Hari Sekhon
#  Date: 2016-01-17 12:56:53 +0000 (Sun, 17 Jan 2016)
#
#  vim:ts=4:sts=4:sw=4:noet
#
#  https://github.com/HariSekhon/Knowledge-Base
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback
#
#  https://www.linkedin.com/in/HariSekhon
#

ifneq ("$(wildcard bash-tools/Makefile.in)", "")
	include bash-tools/Makefile.in
endif

REPO := HariSekhon/Knowledge-Base

CODE_FILES := $(shell git ls-files | grep -E -e '\.md$$' | sort)

# serialize
MAKEFLAGS = -j1

.PHONY: *

# causes weird inheritance condition from Makefile.in that causes triggering of git and printenv targets after build and push
#default: build push
default:
	$(MAKE) build
	@echo
	$(MAKE) push

build: init
	@echo ====================
	@echo Knowledge Base Build
	@echo ====================
	@echo
	@$(MAKE) git-summary
	@echo
	@$(MAKE) index
	@$(MAKE) mdl
	@$(MAKE) references
	@echo "All Checks Passed"

mdl:
	@echo "Checking Markdown for issues"
	@echo
	@mdl *.md

index:
	@echo "Checking all *.md files are in the README.md index"
	@echo
	.github/scripts/check_index.sh
	@echo

references:
	@echo "Checking all *.md files references exist"
	@echo
	.github/scripts/check_markdown_references.sh
	@echo

init:
	@echo
	@echo "running init:"
	git submodule update --init --recursive
	@echo

install: build
	@:

test:
	bash-tools/checks/check_all.sh
	@echo

clean:
	@rm -fv -- *.pyc *.pyo
