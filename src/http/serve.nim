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

proc startHttpServer*(Config: Configurator) =
    ## Start a Madam Server instance using current configuration
    let
        currentProject = getCurrentDir()
        localAddress = "127.0.0.1"
        assetsEndpoint = "/assets/"

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
                    if Config.getAssets().hasFile(path):
                        let fileContent = Config.getAssets().getFile(path)
                        req.send(fileContent)
                    else: req.send(Http404, error.getErrorPage)
                # elif isSecondaryPage(path):

                else: req.send(Http404, error.getErrorPage)

    run(onRequest, initSettings(port=Port(1234), bindAddr=localAddress))