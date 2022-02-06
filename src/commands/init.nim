# Madam 💋 A lightweight local web server for
# Design Prototyping 🎨 and Front-end Development 🌈
# 
# MIT License
# Copyright (c) 2022 George Lemon from OpenPeep
# https://github.com/openpeep/madam

import klymene/cli
import ../configurator
from strutils import `%`

proc runCommand*() =
    let Config = Configurator.init()