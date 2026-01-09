.PHONY: help-common
help-common: ##META Display common make targets
	@printf "\33[32m"
	@echo "semver_audit_go: make targets."
	@printf "\033[0m\n"

	@grep -E "^%?[a-zA-Z0-9/_-]+:.*?##\s" $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build-full
build-full: ## builds the binary
	go build

.PHONY: check-fast
check-fast: ## runs go tests
	go test ./...

.PHONY: check-full
check-full: format check-fast ## formats and runs go tests

.PHONY: init-dev
init-dev: vendor ## initalizes development environment

.PHONY: vendor
vendor: ## vendors dependencies
	go mod vendor

