import ../http/serve
import klymene/cli
import ../configurator
from strutils import `%`

proc runCommand*() =
    let Config = Configurator.init()
    if Config.status == true:
        display("------------------------------------------------", indent=2, br="before")
        display("💃 Madam is dancing on http://$1:$2" % ["127.0.0.1", "1234"], indent=4)
        display("------------------------------------------------", indent=2, br="after")
        # display("Registered routes:", indent=2)
        # TODO list all registered routes as [VERB]  route  entry.html
        startHttpServer(Config.instance)
    else:
        display("👉 Could not start a server on $1:$2" % ["127.0.0.1", "1234"], indent=4)