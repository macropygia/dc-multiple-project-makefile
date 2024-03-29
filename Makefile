PROJECTS := $(foreach path,$(shell ls ./*/docker-compose.yml),$(patsubst ./%/,%,$(dir $(path))))
ALIASES := $(foreach alias,$(shell ls ./*/.alias 2>/dev/null),$(patsubst ./%/,%,$(dir $(alias))))
LATEST := $(strip $(shell cat .dc_latest 2>/dev/null))
$(shell echo -n "" > .dc_latest)
TARGETS = $(strip $(shell cat .dc_latest))
NOW = $(shell date --rfc-2822)
TAIL := all

.PHONY: $(PROJECTS)
.PHONY: up upf build pull down start stop restart pause unpause ps log logs top do ls
.PHONY: info active clean

# Command

define exec
	@-docker compose -f ./$1/docker-compose.yml $2
	@printf "$(NOW)\tdocker compose -f ./$1/docker-compose.yml $2\n" >> .dc_history

endef

define exec_nolog
	@-docker compose -f ./$1/docker-compose.yml $2

endef

up:
	$(foreach t,$(TARGETS),$(call exec,$(t),up -d))

upf:
	$(foreach t,$(TARGETS),$(call exec,$(t),up))

build:
	$(foreach t,$(TARGETS),$(call exec,$(t),$@))

pull:
	$(foreach t,$(TARGETS),$(call exec,$(t),$@))

down:
	$(foreach t,$(TARGETS),$(call exec,$(t),$@))

start:
	$(foreach t,$(TARGETS),$(call exec,$(t),$@))

stop:
	$(foreach t,$(TARGETS),$(call exec,$(t),$@))

restart:
	$(foreach t,$(TARGETS),$(call exec,$(t),$@))

pause:
	$(foreach t,$(TARGETS),$(call exec,$(t),$@))

unpause:
	$(foreach t,$(TARGETS),$(call exec,$(t),$@))

ps:
	$(foreach t,$(TARGETS),$(call exec_nolog,$(t),$@))

logs:
	$(foreach t,$(TARGETS),$(call exec_nolog,$(t),$@))

logs%:
	$(foreach t,$(TARGETS),$(call exec_nolog,$(t),logs --tail=$(@:logs%=%)))

logsf:
	$(foreach t,$(TARGETS),$(call exec_nolog,$(t),logs -f))

logsf%:
	$(foreach t,$(TARGETS),$(call exec_nolog,$(t),logs -f --tail=$(@:logsf%=%)))

top:
	$(foreach t,$(TARGETS),$(call exec_nolog,$(t),$@))

do:
	$(foreach t,$(TARGETS),$(call exec,$(t),$(cmd)))

# Status

active:
	@make all ps | grep running

# List

EXPAND_POS := 18,28

define list
	@printf "$1\t$(shell cat ./$1/.alias 2>/dev/null)\t$(shell cat ./$1/.desc 2>/dev/null)\n" | expand -t $(EXPAND_POS)

endef

info:
	@printf "Project Dir\tAlias\tDescription\n" | expand -t $(EXPAND_POS)
	@echo ------------------------------------------------------------
	$(foreach t,$(TARGETS),$(call list,$(t)))

ls:
	@printf "Project Dir\tAlias\tDescription\n" | expand -t $(EXPAND_POS)
	@echo ------------------------------------------------------------
	$(foreach p,$(PROJECTS),$(call list,$(p)))

# Project

define project
$1:
	@echo $1 >> .dc_latest
endef

$(foreach p,$(PROJECTS),$(eval $(call project,$(p))))

define alias
$(shell cat ./$1/.alias): $1
endef

$(foreach a,$(ALIASES),$(eval $(call alias,$(a))))

# Misc.

clean:
	$(shell rm -f .dc_latest)
	$(shell rm -f .dc_history)
	@echo .dc_* files are removed

# Preset

latest: $(LATEST)

all: $(PROJECTS)

-include ./preset.mk
