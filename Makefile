OUT = dist
DATA = $(OUT)/data
ELM_MAIN = $(OUT)/index.js
ELM_FILES = $(shell find src -iname "*.elm")
URL_BASE = ""

all: $(ELM_MAIN) $(OUT)/index.html

clean:
	@rm -fr $(OUT) elm-stuff tests/elm-stuff node_modules

data:
	@./init_data.py --url-base $(URL_BASE)

$(ELM_MAIN): $(ELM_FILES) node_modules
	npx elm make src/Main.elm --optimize --output $(ELM_MAIN)

$(OUT)/index.html: src/index.html
	@cp src/index.html $(OUT)

node_modules:
	npm install

.PHONY: api-base
api-base:
	pipenv run python -m cogapp -D url_base=$(URL_BASE) -r src/Api.elm

.PHONY: test
test: node_modules
	@npx elm-test

.PHONY: watch
watch:
	@find src | entr make

.PHONY: format
format:
	@elm-format --yes src/ tests/

.PHONY: server
server:
	@http-server $(OUT)  -p 3001
