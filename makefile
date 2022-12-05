REPO_NAME := $(shell basename `git rev-parse --show-toplevel` | tr '[:upper:]' '[:lower:]')
DOCKER_REGISTRY := mathematiguy
IMAGE := ${REPO_NAME}.sif
RUN ?= singularity exec ${IMAGE}
SINGULARITY_ARGS ?=

.PHONY: build shell docker docker-push docker-pull enter enter-root

jupyter:
	${RUN} jupyter lab --ip 0.0.0.0 --port=8888 --NotebookApp.password=$(shell singularity exec ${IMAGE} python -c "from notebook.auth import passwd; print(passwd('jupyter', 'sha1'))")

REMOTE ?= cn-f001
push:
	rsync -rvahzP ${IMAGE} ${REMOTE}.server.mila.quebec:${SCRATCH}

build: ${IMAGE}
${IMAGE}:
	sudo singularity build ${IMAGE} ${SINGULARITY_ARGS} Singularity.recipe

shell:
	singularity shell ${IMAGE} ${SINGULARITY_ARGS}
