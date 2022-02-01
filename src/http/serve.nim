import std/[options,asyncdispatch]
import ./httpbeast, ./assets, ./error
from std/os import getCurrentDir, fileExists
from std/strutils import `%`, startsWith, replace

proc startHttpServer*(localPort: int = 1234) =
    let
        currentProject = getCurrentDir()
        localAddress = "127.0.0.1"
        assetsEndpoint = "/assets/"

    var assets = Assets.init()
    assets.addFile("traho.develop.css", getCurrentDir() & "/example/traho.develop.css")
    assets.addFile("app.css", getCurrentDir() & "/example/app.css")
    assets.addFile("sweetsyntax.min.js", getCurrentDir() & "/dist/sweetsyntax.min.js")

    proc onRequest(req: Request): Future[void] =
        if req.httpMethod == some(HttpGet):
            var path = req.path.get()
            case path
            of "/":
                let filepath = currentProject & "/example/index.html"
                if fileExists(filepath):
                    req.send(readFile(filepath))
                else:
                    req.send(Http404, error.getErrorPage)
            else:
                if path.startsWith(assetsEndpoint):
                    path = replace(path, assetsEndpoint)
                    if assets.hasFile(path):
                        req.send(assets.getFile(path))
                    else:
                        req.send("Not okay")
                else: req.send(Http404, error.getErrorPage)

    run(onRequest, initSettings(port=Port(localPort), bindAddr=localAddress))