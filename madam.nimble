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
requires "klymene"
requires "httpbeast >= 0.4.0"

include ./tasks/dev
include ./tasks/prod