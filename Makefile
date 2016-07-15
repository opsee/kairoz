PROJECT := kairoz
GITCOMMIT := $(shell git rev-parse --short HEAD)
GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
GITUNTRACKEDCHANGES := $(shell git status --porcelain --untracked-files=no)
ifneq ($(GITUNTRACKEDCHANGES),)
 	GITCOMMIT := $(GITCOMMIT)-dirty
	endif

all: build

fmt:
	@gofmt -w ./

build:
	docker build -t quay.io/opsee/$(PROJECT):$(GITCOMMIT) .

run: build
	docker run \
		-p 9113:8080 \
		--rm \
		quay.io/opsee/$(PROJECT):$(GITCOMMIT)

push:
	docker push quay.io/opsee/$(PROJECT):$(GITCOMMIT)

.PHONY: build run all push
