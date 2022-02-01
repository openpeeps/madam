import std/[options,asyncdispatch]
import httpbeast, ../error
from os import getCurrentDir, fileExists

proc runCommand*() =
    let currentProject = getCurrentDir()
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

    run(onRequest, initSettings(port=Port(1234), bindAddr="127.0.0.1"))
    echo "test"