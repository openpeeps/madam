# Madam 💋 A lightweight local web server for
# Design Prototyping 🎨 and Front-end Development 🌈
# 
# MIT License
# Copyright (c) 2022 George Lemon from OpenPeep
# https://github.com/openpeep/madam

import std/[options,asyncdispatch]
import ./httpbeast, ./defaults
from std/os import getCurrentDir, fileExists
from std/strutils import `%`, startsWith, replace
import ../assets, ../configurator, ../routes
from klymene/cli import display

# proc isSecondaryPage(): bool =
#     return false

# proc getPageContents(): string =
#     readFile(filepath)

type
    Logger = object
        code: HttpCode
        verb: HttpMethod
        path: string

proc httpGetRequest(route: string, config: Configurator): tuple[code: HttpCode, body: string] =
    let assetsEndpoint = "/assets/"
    var path = route
    var response = (code: Http404, body: defaults.getErrorPage)
    case path
    of "/":
        let indexFilePath = config.getViewsPath("index.html")
        if fileExists(indexFilePath):
            response = (code: Http200, body: readFile(indexFilePath))
        else:
            response = (code: Http200, body: defaults.getWelcomeScreen)
    else:
        if path.startsWith(assetsEndpoint):
            # try serve static assets if is in path
            path = replace(path, assetsEndpoint)
            if config.getAssets().hasFile(path):
                response = (code: Http200, body: config.getAssets().getFile(path))
        elif config.routes.getExists(path):
            let routeObject = config.routes.getRoute(HttpGet, path)
            if fileExists(routeObject.getFile()):
                response = (code: Http200, body: readFile(routeObject.getFile()))
    return response

proc startHttpServer*(config: Configurator, isLoggerEnabled = false) =
    ## Start a Madam Server instance using current configuration
    let
        currentProject = getCurrentDir()
        localAddress = "127.0.0.1"

    proc onRequest(req: Request): Future[void] =
        let path = req.path.get()
        var logger = Logger()
        if req.httpMethod == some(HttpGet):
            let (code, body) = httpGetRequest(path, config)
            logger.code = code
            logger.verb = HttpGet
            logger.path = path
            req.send(code, body)
        else:
            req.send(Http404, "nope")
        if isLoggerEnabled:
            display("$1 $2 ⟶ $3" % [$logger.code, $logger.verb, logger.path])
    run(onRequest, initSettings(port=Port(config.getPort()), bindAddr=localAddress))