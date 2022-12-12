REPO_NAME := $(shell basename `git rev-parse --show-toplevel` | tr '[:upper:]' '[:lower:]')
DOCKER_REGISTRY := mathematiguy
IMAGE := ${REPO_NAME}.sif
RUN ?= singularity exec --nv ${IMAGE}
SINGULARITY_ARGS ?=

.PHONY: build shell docker docker-push docker-pull enter enter-root

train_e2e_data:
	${RUN} bash -c 'cd improved-diffusion && python scripts/run_train.py --diff_steps 2000 --model_arch transformer --lr 0.0001 --lr_anneal_steps 200000 --seed 102 --noise_schedule sqrt --in_channel 16 --modality e2e-tgt --submit no --padding_mode block --app "--predict_xstart True --training_mode e2e --vocab_size 821 --e2e_train ../datasets/e2e_data " --notes xstart_e2e'

train_rocstory:
	${RUN} bash -c 'cd improved-diffusion && python scripts/run_train.py --diff_steps 2000 --model_arch transformer --lr 0.0001 --lr_anneal_steps 400000 --seed 101 --noise_schedule sqrt --in_channel 128 --modality roc --submit no --padding_mode pad --app "--predict_xstart True --training_mode e2e --vocab_size 11043 --roc_train ../datasets/ROCstory " --notes xstart_e2e --bsz 64'

jupyter:
	${RUN} jupyter lab --ip 0.0.0.0 --port=8888 --NotebookApp.password=$(shell singularity exec ${IMAGE} python -c "from notebook.auth import passwd; print(passwd('jupyter', 'sha1'))")

REMOTE ?= cn-f001
push:
	rsync -rvahzP ${IMAGE} ${REMOTE}.server.mila.quebec:${SCRATCH}

build: ${IMAGE}
${IMAGE}:
	sudo singularity build ${IMAGE} ${SINGULARITY_ARGS} Singularity

shell:
	singularity shell ${IMAGE} ${SINGULARITY_ARGS}

root-shell:
	sudo singularity shell ${IMAGE} ${SINGULARITY_ARGS}
