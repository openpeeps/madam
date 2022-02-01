import std/[options,asyncdispatch]
import ../http/httpbeast, ../error
from std/os import getCurrentDir, fileExists
from std/strutils import `%`
import klymene/cli

proc runCommand*() =
    let
        currentProject = getCurrentDir()
        localAddress = "127.0.0.1"
        localPort = 1234
    proc onRequest(req: Request): Future[void] =
        if req.httpMethod == some(HttpGet):
            case req.path.get()
            of "/":
                let filepath = currentProject & "/example/index.html"
                if fileExists(filepath):
                    req.send(readFile(filepath))
                else:
                    req.send(Http404, error.getErrorPage)
            else:
                req.send(Http404, error.getErrorPage)
    display("------------------------------------------------", indent=2, br="before")
    display("💃 Madam is dancing on http://$1:$2" % [localAddress, $localPort], indent=4)
    display("------------------------------------------------", indent=2, br="after")
    run(onRequest, initSettings(port=Port(localPort), bindAddr=localAddress))