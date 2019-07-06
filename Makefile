.PHONY: all dev clean build env-up env-down run

all: clean build env-up run

dev: build run

##### BUILD
build:
	@echo "Build ..."
#	@dep ensure
	@go build
	@echo "Build done"

##### ENV
env-up:
	@echo "Start environment ..."
	@cd fixtures/first-network && docker-compose -f docker-compose-e2e.yaml up --force-recreate -d
	@echo "Environment up"

env-down:
	@echo "Stop environment ..."
	@cd fixtures/first-network && docker-compose -f docker-compose-e2e.yaml down
	@echo "Environment down"

##### RUN
run:
	@echo "Start app ..."
	@./education

##### CLEAN
clean: env-down
	@echo "Clean up ..."
	@docker volume prune
	@docker network prune
	@rm -rf /tmp/example-* example
	@docker rm -f -v `docker ps -a --no-trunc | grep "example" | cut -d ' ' -f 1` 2>/dev/null || true
	@docker rmi `docker images --no-trunc | grep "example" | cut -d ' ' -f 1` 2>/dev/null || true
	@echo "Clean up done"

:wq