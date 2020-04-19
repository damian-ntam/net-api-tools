DOCKER_IMAGE = writememe/net-api
DOCKER_TAG = latest
ENV_FILE = .env-vars

.DEFAULT_GOAL := help

.PHONY: help
help:
	@grep '^[a-zA-Z]' $(MAKEFILE_LIST) | \
	sort | \
	awk -F ':.*?## ' 'NF==2 {printf "\033[36m  %-25s\033[0m %s\n", $$1, $$2}'

.PHONY:	lint-all
lint-all:	black pylama yamllint  ## Perform all linting checks (black, pylama and yamllint).

.PHONY:	black
black: ## Format code using black
	@echo "--- Performing black reformatting ---"
	black .

.PHONY:	pylama
pylama:	## Perform python linting using pylama
	@echo "--- Performing pylama linting ---"
	pylama .

.PHONY:	yamllint
yamllint:	## Perform YAML linting using yamllint
	@echo "--- Performing yamllint linting ---"
	yamllint .

venv: ## Install virtualenv, create virtualenv, install requirements for Python 3
	@echo "--- Creating virtual environment and installing requirements (Python3.x) ---"
	virtualenv --python=`which python3` venv
	source /venv/bin/activate
	pip install -r ./requirements.txt

build: ## Build docker container
	docker build -t $(DOCKER_IMAGE):$(DOCKER_TAG) .

run: ## Run docker container on port 5000
	docker run -d --env-file=$(ENV_FILE) -p 5000:5000 \
	$(DOCKER_IMAGE):$(DOCKER_TAG)