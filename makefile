
SHELL=/bin/bash
SEFORIM=shnaim_mikra rambam chumash_rashi nach
SCRIPTS=./scripts/

.PHONY: default all sort release $(SEFORIM)

default: $(SEFORIM) release

all: $(SEFORIM) release

release:
	$(SCRIPTS)releases.bash

shnaim_mikra:
	$(SCRIPTS)shnaim_mikra/shnaim_mikra.bash

rambam:
	$(SCRIPTS)rambam/rambam.bash

chumash_rashi:
	$(SCRIPTS)chumash_rashi/chumash_rashi.bash

nach:
	$(SCRIPTS)nach/nach.bash

