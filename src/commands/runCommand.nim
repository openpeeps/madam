import kapsis/[runtime, cli]
import std/[strutils, os, osproc]
import ../madam/[serve, configurator]

proc runCommand*(v: Values) =
  let Config = Configurator.init()
  let port = Config.instance.getPort()
  if Config.status == true:
    display("------------------------------------------------", indent=2, br="before")
    display("💃 Madam is dancing on http://$1:$2" % ["localhost", $port], indent=4)
    display("------------------------------------------------", indent=2, br="after")
    # display("Registered routes:", indent=2)
    # TODO list all registered routes as [VERB]  route  entry.html
    sleep(200)
    discard execCmd("open http://localhost:" & $port)
    try:
      startHttpServer(Config.instance)
    except OSError:
      echo getCurrentExceptionMsg()

  else:
    display("👉 Could not start a server on $1:$2" % ["localhost", $port], indent=4)