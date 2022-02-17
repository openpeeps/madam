# Package

version       = "0.1.0"
author        = "George Lemon"
description   = "Local webserver for Design Prototyping and Front-end Development"
license       = "MIT"
srcDir        = "src"
bin           = @["madam"]
binDir        = "bin"

# Dependencies

requires "nim >= 1.6.0"
requires "klymene"          # https://github.com/openpeep/klymene
requires "nyml"             # https://github.com/openpeep/nyml
requires "tim"

include ./tasks/dev
include ./tasks/prod