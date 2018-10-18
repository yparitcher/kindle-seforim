
SHELL=/bin/bash
SEFORIM=shnaim_mikra rambam
SCRIPTS=./scripts/

.PHONY: default all sort release $(SEFORIM)

default: $(SEFORIM) release

all: sort $(SEFORIM) release

sort:
	$(SCRIPTS)sort_files.sh

release:
	$(SCRIPTS)releases.bash

shnaim_mikra:
	$(SCRIPTS)shnaim_mikra/shnaim_mikra.bash

rambam:
	$(SCRIPTS)rambam/rambam.bash

