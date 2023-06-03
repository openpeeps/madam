import emitter
import kapsis/[runtime, cli]
import std/[strutils, os, osproc, typeinfo]
import ../madam/[serve, configurator]

proc runCommand*(v: Values) =
  let config = newConfig()
  let port = config.instance.getPort()
  if config.status == true:
    Event.init()
    include ../madam/listeners
    display("------------------------------------------------", indent=2, br="before")
    display("💃 Madam is dancing http://$1:$2" % ["localhost", $port], indent=4)
    display("------------------------------------------------", indent=2, br="after")
    # display("Registered routes:", indent=2)
    # TODO list all registered routes as [VERB]  route  entry.html
    sleep(200)
    if config.instance.useBrowser():
      discard execCmd("open http://localhost:" & $port)
    try:
      startHttpServer(config.instance)
    except OSError:
      echo getCurrentExceptionMsg()
  # else:
    # display("👉 Could not start a server on $1:$2" % ["localhost", $port], indent=4)