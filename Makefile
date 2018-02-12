OUT = dist
DATA = $(OUT)/data
ELM_MAIN = $(OUT)/index.js
ELM_FILES = $(shell find src -iname "*.elm")

all: $(ELM_MAIN) $(OUT)/index.html

clean:
	@rm -fr $(OUT) elm-stuff tests/elm-stuff

data:
	@./init_data.py

$(ELM_MAIN): $(ELM_FILES)
	elm-make --debug --yes src/Main.elm --warn --output $(ELM_MAIN)

$(OUT)/index.html: src/index.html
	@cp src/index.html $(OUT)

api-base:
	pipenv run python -m cogapp -r src/Api.elm

test:
	@elm-test

watch:
	@find src | entr make

format:
	@elm-format --yes src/ tests/

server:
	@http-server $(OUT)  -p 3001
