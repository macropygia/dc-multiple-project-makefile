PROJECTS := $(foreach path,$(shell ls ./*/docker-compose.yml),$(patsubst ./%/,%,$(dir $(path))))
ALIASES := $(foreach alias,$(shell ls ./*/ALIAS),$(patsubst ./%/,%,$(dir $(alias))))
LATEST := $(strip $(shell cat .dc_latest 2>/dev/null))
$(shell echo -n "" > .dc_latest)
TARGETS = $(strip $(shell cat .dc_latest))
NOW = $(shell date --rfc-2822)

.PHONY: $(PROJECTS)
.PHONY: up build pull down start stop restart pause unpause ps top do ls
.PHONY: info active

# Command

define exec
	@-docker-compose -f ./$1/docker-compose.yml $2
	@echo -e "$(NOW)\tdocker-compose -f ./$1/docker-compose.yml $2" >> .dc_history

endef

define exec_nolog
	@-docker-compose -f ./$1/docker-compose.yml $2

endef

up:
	$(foreach t,$(TARGETS),$(call exec,$(t),up -d))

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

top:
	$(foreach t,$(TARGETS),$(call exec_nolog,$(t),$@))

do:
	$(foreach t,$(TARGETS),$(call exec,$(t),$(cmd)))

# Info

define show
	@echo -e "$1\t$(shell cat ./$1/DESCRIPTION 2>/dev/null)" | expand -t 18

endef

info:
	$(foreach t,$(TARGETS),$(call show,$(t)))

# Status

active:
	@make all ps | grep Up

# List

define list
	@echo -e "$1\t$(shell cat ./$1/ALIAS 2>/dev/null)\t$(shell cat ./$1/DESCRIPTION 2>/dev/null)" | expand -t 18,28

endef

ls:
	@echo -e "Project Name\tAlias\tDescription" | expand -t 18,28
	@echo ------------------------------------------------------------
	$(foreach p,$(PROJECTS),$(call list,$(p)))

# Project

define project
$1:
	@echo $1 >> .dc_latest
endef

$(foreach p,$(PROJECTS),$(eval $(call project,$(p))))

define alias
$(shell cat ./$1/ALIAS): $1
endef

$(foreach a,$(ALIASES),$(eval $(call alias,$(a))))

# Misc.

clean:
	$(shell rm -f .dc_latest)
	$(shell rm -f .dc_history)

# Preset

latest: $(LATEST)

all: $(PROJECTS)

-include ./preset.mk
