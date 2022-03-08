
SHELL=/bin/bash
SCRIPTS=./scripts/

SEFORIM=shnaim_mikra rambam chumash_rashi nach talmud Steinsaltz_talmud_H_E Kitzur_Shulchan_Aruch Arukh_HaShulchan Shulchan_Arukh Mishnah gmara_nocha Steinsaltz_talmud_Hebrew Chumash_Rashi_English Shulchan_Aruch_Harav Mishnah_Berurah Jastrow Kuzari

.PHONY: default all sort release apnx $(SEFORIM)

default: all

all:
	$(MAKE) $(SEFORIM)
	$(MAKE) apnx
	$(MAKE) release

release:
	$(SCRIPTS)releases.bash

apnx:
	calibre-debug $(SCRIPTS)apnx.py

$(SEFORIM):
	$(SCRIPTS)$@/$@.bash
