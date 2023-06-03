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
requires "nyml"
requires "tim"
requires "httpx"
requires "kapsis"

task dev, "Compile Madam for development purposes":
  echo "\n✨ Compiling Madam " & $version & " for dev"
  exec "nimble build --gc:arc --threads:on"

task prod, "Compile Madam for production":
  echo "\n✨ Compiling Madam " & $version & " for prod"
  exec "nimble build --gc:arc -d:release --threads:on --opt:size --spellSuggest"