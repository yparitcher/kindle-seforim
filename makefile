
SHELL=/bin/bash
SEFORIM=shnaim_mikra rambam chumash_rashi nach talmud Steinsaltz_talmud_H_E Kitzur_Shulchan_Aruch Arukh_HaShulchan Shulchan_Arukh Mishnah gmara_nocha Steinsaltz_talmud_Hebrew Chumash_Rashi_English
SCRIPTS=./scripts/

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

Kitzur_Shulchan_Aruch:
	$(SCRIPTS)Kitzur_Shulchan_Aruch/Kitzur_Shulchan_Aruch.bash

Arukh_HaShulchan:
	$(SCRIPTS)Arukh_HaShulchan/Arukh_HaShulchan.bash

Shulchan_Arukh:
	$(SCRIPTS)Shulchan_Arukh/Shulchan_Arukh.bash

Mishnah:
	$(SCRIPTS)Mishnah/Mishnah.bash

gmara_nocha:
	$(SCRIPTS)gmara_nocha/gmara_nocha.bash

Steinsaltz_talmud_Hebrew:
	$(SCRIPTS)Steinsaltz_talmud_Hebrew/Steinsaltz_talmud_Hebrew.bash

Chumash_Rashi_English:
	$(SCRIPTS)Chumash_Rashi_English/Chumash_Rashi_English.bash
