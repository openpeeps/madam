import kapsis/runtime
import ../madam/configurator
import strutils

proc runCommand*(v: Values) =
  let Config = Configurator.init()