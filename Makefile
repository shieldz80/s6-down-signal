# Always use bash as the shell.
SHELL:=bash

# Enable bash strict mode.
.SHELLFLAGS:=-eu -o pipefail -c

# Delete it's target file if a Make rule fails.
.DELETE_ON_ERROR:

MAKEFLAGS += --no-builtin-rules

DC:=docker compose

SERVICES:=nginx1 nginx2

.PHONY: ps ps-a
ps ps-a: ps%:
	@ARGS=; \
	[[ "$(strip $(subst -, ,$*))" = "a" ]] && ARGS="$$ARGS --all"; \
	$(DC) ps --format 'table {{.ID}}\t{{.Name}}\t{{.Image}}\t{{.Command}}\t{{.Service}}\t{{.RunningFor}}\t{{.State}}' $$ARGS

.PHONY: up up-build
up up-build: up%:
	@ARGS=; \
	[[ "$(strip $(subst -, ,$*))" = "build" ]] && ARGS="$$ARGS --build"; \
	$(DC) up -d $$ARGS

DOWN_PREFIX:=down
DOWN_TARGETS=$(DOWN_PREFIX) $(addprefix $(DOWN_PREFIX)-,15 20 30 60 90)

.PHONY: $(DOWN_TARGETS)
$(DOWN_TARGETS): $(DOWN_PREFIX)%:
	@MATCH=$*; \
	TIMEOUT="$${MATCH:1}"; \
	[[ -n $$TIMEOUT ]] && ARGS="-t $$TIMEOUT"; \
	$(DC) down -v $${ARGS:-}

STOP_PREFIX:=stop
STOP_TARGETS:=$(STOP_PREFIX) $(addprefix $(STOP_PREFIX)-,$(SERVICES))

.PHONY: $(STOP_TARGETS)
$(STOP_TARGETS): $(STOP_PREFIX)%:
	@MATCH=$*; \
	SVC="$${MATCH:1}"; \
	$(DC) stop -t 30 $$SVC

.PHONY: build build-nc
build build-nc: build%:
	@ARGS=; \
	[[ "$(strip $(subst -, ,$*))" = "nc" ]] && ARGS="$$ARGS --no-cache"; \
	$(DC) build --progress=plain $$ARGS

SH-PREFIX:=sh-
SH-TARGETS:=$(addprefix $(SH-PREFIX),$(SERVICES))

.PHONY: $(SH-TARGETS)
$(SH-TARGETS): $(SH-PREFIX)%:
	@$(DC) exec $* sh

LOG_PREFIX:=logs-4-
LOG_TARGETS:=$(addprefix $(LOG_PREFIX),$(SERVICES))

.PHONY: $(LOG_TARGETS)
$(LOG_TARGETS): $(LOG_PREFIX)%:
	@trap "exit 0" INT EXIT SIGTERM; \
	$(DC) logs -f $*

.PHONY: kill-containers
kill-containers:
	@docker container rm -f $$(docker container ls -aq)

