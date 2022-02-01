import ../http/serve
import klymene/cli

from strutils import `%`

proc runCommand*() =
    display("------------------------------------------------", indent=2, br="before")
    display("💃 Madam is dancing on http://$1:$2" % ["127.0.0.1", "1234"], indent=4)
    display("------------------------------------------------", indent=2, br="after")
    serve.startHttpServer()