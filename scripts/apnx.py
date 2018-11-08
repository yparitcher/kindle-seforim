#!/usr/bin/env python

import sys
from calibre.devices.kindle.apnx import APNXBuilder
apnx_builder = APNXBuilder()

docs="./output"
method = "accurate"


for root, dirs, files in os.walk(docs):
    for name in files:
        mobi_path = os.path.join(root, name)
        if name.lower().endswith('.azw3'):
            apnx_path = os.path.join(root, os.path.splitext(name)[0] + '.apnx')
            apnx_builder.write_apnx(mobi_path, apnx_path, method)
