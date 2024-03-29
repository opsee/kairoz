ENVIRONMENT ?= test
PROJECT := kairoz
GITCOMMIT := $(shell git rev-parse --short HEAD)
GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
GITUNTRACKEDCHANGES := $(shell git status --porcelain --untracked-files=no)
ifneq ($(GITUNTRACKEDCHANGES),)
 	GITCOMMIT := $(GITCOMMIT)-dirty
	endif

IMAGE_VERSION ?= $(GITCOMMIT)

all: build

fmt:
	@gofmt -w ./

build:
	docker build -t quay.io/opsee/$(PROJECT):$(GITCOMMIT) .

run: build
	docker run \
		-p 9113:9113 \
		--rm \
		quay.io/opsee/$(PROJECT):$(GITCOMMIT)
push:
	docker push quay.io/opsee/$(PROJECT):$(GITCOMMIT)

deploy-plan: terraform
	TF_VAR_image_version=$(IMAGE_VERSION) $(MAKE) -C terraform $(ENVIRONMENT)-plan

deploy: deploy-plan
	$(MAKE) -C terraform $(ENVIRONMENT)-apply

.PHONY: build run all push
