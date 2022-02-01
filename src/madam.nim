# This is Madam 💅 A simple and fast local web server
# for prototyping and front-end development.
# 
# MIT License
# Copyright (c) 2022 George Lemon from OpenPeep
# https://github.com/openpeep/madam

import klymene
import ./commands/[watch]
from strutils import `%`

# from macros import dumpAstGen

const version = "0.1.0"
const binName = "madam"

let sheet = """
# Madam $2 💅 A local web server for Prototyping and Front-end Development #
# For updates, tips and tricks go to github.com/openpeep/madam #

$3
  $1 run [--quiet]                  # Start Madam server in current project directory #

$4
  -h --help                       # Show this screen. #
  -v --version                    # Show version. #
""" % [binName, version, "\e[1mUsage:\e[0m", "\e[1mOptions:\e[0m"]

let args = newCommandLine(sheet, version=version, binaryName=binName)

if isCommand("run", args):   watch.runCommand()
elif isCommand("stop", args):  echo "watching"