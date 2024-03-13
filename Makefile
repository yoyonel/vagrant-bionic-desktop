.DEFAULT_GOAL := help

DIR := $(shell realpath .)

.PHONY: all
all: build_or_update docker	## Build vagrant box and docker image

.PHONY: vagrant-ssh
vagrant-ssh: ## Launch a SSH connection on vagrant box
	@vagrant ssh --color --timestamp --no-tty -c zsh -- -X

.PHONY: vagrant-tests
vagrant-tests: ## Launch versions checking on vagrant box
	@./vagrant_tests.sh

.PHONY: vagrant-rebuild
vagrant-rebuild: ## ReBuild from scratch vagrant box
	@./rebuild.sh

.PHONY: build_or_update
vagrant-build_or_update: ## Build Or Update vagrant box
	@./build_or_update.sh

.PHONY: docker-build
docker-build: ## Build docker image
	@docker build -t vagrant-bionic-desktop:debian-latest --progress=plain . 2>&1 | tee docker-build.log

.PHONY: docker-rebuild
docker-rebuild: ## Build docker image without caches
	@docker build --no-cache -t vagrant-bionic-desktop:debian-latest --progress=plain . 2>&1 | tee docker-build.log
	
.PHONY: docker-tests
docker-tests: ## Launch versions checking on docker container
	@docker run -it --rm vagrant-bionic-desktop:debian-latest zsh -c "source ~/.zshrc 2>/dev/null; ./check-versions.sh 2>/dev/null"

.PHONY: docker-shell
docker-shell: ## Run a shell command interpreter on docker container
	@docker run -it --rm vagrant-bionic-desktop:debian-latest zsh

.PHONY: clean
clean: ## Remove vagrant artifacts
	@vagrant destroy --force

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'
