# Oneshell means I can run multiple lines in a recipe in the same shell, so I don't have to
# chain commands together with semicolon
.ONESHELL:
# Need to specify bash in order for conda activate to work.
SHELL=/bin/bash
# Note that the extra activate is needed to ensure that the activate floats env to the front of PATH

clean: clean-pyc clean-test
quality: set-style-dep check-quality
style: set-style-dep set-style
setup: set-precommit set-style-dep set-test-dep set-git set-dev
test: set-test-dep set-test


##### basic #####
set-precommit:
	pip3 install pre-commit==2.17.0
	pre-commit install

set-style-dep:
	pip3 install click==8.0.4 isort==5.9.3 black==21.7b0 flake8==3.9.2

set-git:
	git config --local commit.template .gitmessage

set-dev:
	pip3 install -r requirements.txt

set-test-dep:
	pip3 install pytest==6.2.4

set-test:
	python3 -m pytest tests/

set-style:
	black --config pyproject.toml .
	isort --settings-path pyproject.toml .
	flake8 .

check-quality:
	black --config pyproject.toml --check .
	isort --settings-path pyproject.toml --check-only .
	flake8 .

ci-check-quality:
	pip3 install click==8.0.4 isort==5.9.3 black==21.7b0 flake8==3.9.2
	black --config pyproject.toml --check .
	isort --settings-path pyproject.toml --check-only .
	flake8 .

#####  clean  #####
clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test:
	rm -f .coverage
	rm -f .coverage.*
	rm -rf .pytest_cache
	rm -rf .mypy_cache
