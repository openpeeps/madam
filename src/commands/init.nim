# Madam 💋 A lightweight local web server for
# Design Prototyping 🎨 and Front-end Development 🌈
# 
# GPLv3 License
# Copyright (c) 2022 George Lemon from OpenPeep
# https://github.com/openpeep/madam

import klymene/cli
import ../configurator
from strutils import `%`

proc runCommand*() =
    ## Command for generating a `madam.yml` configuration file
    display("Generate a Madam Server Configuration", indent=2)
    # let Config = Configurator.init()
    # let (source_path, public_path) = Config.instance.getAssetsPath()
