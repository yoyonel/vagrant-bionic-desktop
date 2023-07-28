DIR := $(shell realpath .)

all: build_or_update

vagrant-ssh:
	@vagrant ssh --color --timestamp --no-tty -c zsh -- -X

vagrant-tests:
	@./vagrant_tests.sh

rebuild:
	@./rebuild.sh

build_or_update:
	@./build_or_update.sh

clean:
	@vagrant destroy --force

.PHONY: all build_or_update clean
