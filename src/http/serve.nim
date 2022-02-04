import std/[options,asyncdispatch]
import ./httpbeast, ./assets, ./error
from std/os import getCurrentDir, fileExists
from std/strutils import `%`, startsWith, replace

# proc isSecondaryPage(path: string) =


proc startHttpServer*(localPort: int = 1234) =
    let
        currentProject = getCurrentDir()
        localAddress = "127.0.0.1"
        assetsEndpoint = "/assets/"

    var assets = Assets.init()
    assets.addFile("traho.develop.css", getCurrentDir() & "/example/traho.develop.css")
    assets.addFile("app.css", getCurrentDir() & "/example/app.css")
    assets.addFile("sweetsyntax.min.js", getCurrentDir() & "/dist/sweetsyntax.min.js")
    assets.addFile("logo.png", getCurrentDir() & "/example/logo.png")
    assets.addFile("sweetworker.js", getCurrentDir() & "/example/sweetworker.js")

    proc onRequest(req: Request): Future[void] =
        if req.httpMethod == some(HttpGet):
            var path = req.path.get()
            case path
            of "/":
                let filepath = currentProject & "/example/pages/index.html"
                if fileExists(filepath):
                    let indexPage = readFile(filepath)
                    req.send(indexPage)
                else:
                    req.send(Http404, error.getErrorPage)
            of "/full":
                let filepath = currentProject & "/example/pages/full.html"
                let indexPage = readFile(filepath)
                req.send(indexPage)
            else:
                if path.startsWith(assetsEndpoint):
                    # Handle public assets
                    path = replace(path, assetsEndpoint)
                    if assets.hasFile(path):
                        let fileContent = assets.getFile(path)
                        req.send(fileContent)
                    else: req.send(Http404, error.getErrorPage)
                # elif isSecondaryPage(path):

                else: req.send(Http404, error.getErrorPage)

    run(onRequest, initSettings(port=Port(localPort), bindAddr=localAddress))