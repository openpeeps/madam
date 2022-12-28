# Madam 💋 A lightweight local web server for
# Design Prototyping 🎨 and Front-end Development 🌈
# 
# MIT License
# Copyright (c) 2022 George Lemon from OpenPeep
# https://github.com/openpeep/madam

import klymene
import ./commands/[init, run, build]
from strutils import `%`

# from macros import dumpAstGen

const version = "0.1.0"
const binName = "madam"

let sheet = """
# Madam $2 💋 Local Web Server for Design Prototyping and Front-end Development #
# Updates, tips and tricks 👉 https://github.com/openpeep/madam #

$3
  $1 init                           # Create a new Madam server config #
  $1 run [--quiet]                  # Run local server. Use quiet flag for running in background #
  $1 build                          # Build current project to Static HTML pages #

$4
  -h --help                       # Show this screen. #
  -v --version                    # Show version. #
""" % [binName, version, "\e[1mUsage:\e[0m", "\e[1mOptions:\e[0m"]

let args = newCommandLine(sheet, version=version, binaryName=binName)

if isCommand("init", args):
  init.runCommand()
elif isCommand("run", args):
  run.runCommand()
elif isCommand("build", args):
  build.runCommand()