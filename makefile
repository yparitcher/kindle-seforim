
SHELL=/bin/bash
SEFORIM=shnaim_mikra rambam chumash_rashi nach talmud Steinsaltz_talmud_H_E
SCRIPTS=./scripts/

.PHONY: default all sort release apnx $(SEFORIM)

default: all

all:
	$(MAKE) $(SEFORIM)
	$(MAKE) apnx
	$(MAKE) release

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
	
talmud:
	$(SCRIPTS)talmud/talmud.bash

Steinsaltz_talmud_H_E:
	$(SCRIPTS)Steinsaltz_talmud_H_E/Steinsaltz_talmud_H_E.bash

apnx:
	calibre-debug $(SCRIPTS)apnx.py
