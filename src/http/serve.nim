# Madam 💋 A lightweight local web server for
# Design Prototyping 🎨 and Front-end Development 🌈
# 
# MIT License
# Copyright (c) 2022 George Lemon from OpenPeep
# https://github.com/openpeep/madam

import std/[options,asyncdispatch]
import ./httpbeast, ./error
from std/os import getCurrentDir, fileExists
from std/strutils import `%`, startsWith, replace

import ../assets, ../configurator

# proc isSecondaryPage(): bool =
#     return false

# proc getPageContents(): string =
#     readFile(filepath)

proc httpGetRequest(route: string, config: Configurator): tuple[code: HttpCode, body: string] =
    let assetsEndpoint = "/assets/"
    let errorNotFoundTuple = (code: Http404, body: error.getErrorPage)
    var path = route
    case path
    of "/":
        let indexFilePath = config.getViewsPath("index.html")
        echo indexFilePath
        if fileExists(indexFilePath):
            return (code: Http200, body: readFile(indexFilePath))
        else:
            return errorNotFoundTuple
    else:
        if path.startsWith(assetsEndpoint):
            path = replace(path, assetsEndpoint)
            if config.getAssets().hasFile(path):
                return (code: Http200, body: config.getAssets().getFile(path))
            else:
                return errorNotFoundTuple
        else: return errorNotFoundTuple

proc startHttpServer*(config: Configurator) =
    ## Start a Madam Server instance using current configuration
    let
        currentProject = getCurrentDir()
        localAddress = "127.0.0.1"

    proc onRequest(req: Request): Future[void] =
        if req.httpMethod == some(HttpGet):
            let (code, body) = httpGetRequest(req.path.get(), config)
            req.send(code, body)
        else:
            req.send(Http404, "nope")

    run(onRequest, initSettings(port=Port(1234), bindAddr=localAddress))