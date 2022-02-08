# Package

version       = "0.1.0"
author        = "George Lemon"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["madam"]
binDir        = "bin"

# Dependencies

requires "nim >= 1.6.0"
requires "klymene"          # https://github.com/openpeep/klymene
requires "nyml"             # https://github.com/openpeep/nyml

include ./tasks/dev
include ./tasks/prod