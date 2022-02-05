# Madam 💋 A lightweight local web server for
# Design Prototyping 🎨 and Front-end Development 🌈
# 
# MIT License
# Copyright (c) 2022 George Lemon from OpenPeep
# https://github.com/openpeep/madam

import nyml
from std/os import getCurrentDir, fileExists, normalizePath, splitFile
from std/strutils import `%`, replace
import ./assets, ./routes
from klymene/cli import display

const configFile = "madam.yml"

type
    Configurator* = object
        name: string
        path: string
        port: int
        templates: tuple[layouts, views, partials: string]
        routes: Router
        assets: Assets

proc getName*[T: Configurator](config: T): string =
    return config.name

proc getPath*[T: Configurator](config: T, path: string): string =
    ## Return the current project path
    var filepath = getCurrentDir() & "/" & config.path
    filepath = if path.len != 0: (filepath & "/" & path) else: filepath
    filepath.normalizePath()
    return filepath

proc getTemplatesPath[T: Configurator](config: T, contentType: string, filePath: string): string =
    var dirpath: string
    case contentType:
    of "layouts": dirpath = config.templates.layouts
    of "views": dirpath = config.templates.views
    of "partials": dirpath = config.templates.partials
    return config.getPath(dirpath & "/" & filePath)

proc getViewsPath*[T: Configurator](config: T, path: string): string =
    return config.getTemplatesPath("views", "/" & path)

proc getLayoutsPath*[T: Configurator](config: T, path: string): string =
    return config.getTemplatesPath("layouts", "/" & path)

proc getPartialsPath*[T: Configurator](config: T, path: string): string =
    return config.getTemplatesPath("partials", "/" & path)

proc getPort*[T: Configurator](config: T): int =
    return config.port

proc getRoutes*[T: Configurator](config: T): Router =
    return config.routes

proc getAssets*[T: Configurator](config: T): Assets =
    return config.assets

proc collectRoutes[A: Configurator, B: Router](config: var A, router: var B, routes: JsonNode): B =
    for route, file in routes.pairs():
        let fileName = file.getStr
        let filePath = config.getViewsPath(fileName)
        if not filePath.fileExists():
            display("👉 \"$1\" file could not be found. (ignored)" % [filename], indent=4)
        # elif mime.getMimetype(replace(filePath.splitFile().ext, ".", "")) != "text/html":
            # display("👉 \"$1\" file has a different extension. Only \".html\" or \".htm\" allowed. (ignored)" % [filename], indent=4)
        else: router.get(route, file.getStr())
    return router

proc collectAssets[A: Configurator, B: Assets](config: var A, assets: var B, assetsNode: JsonNode): B =
    assets.addFile("traho.develop.css", config.getPath("/traho.develop.css"))
    assets.addFile("app.css", config.getPath("/app.css"))
    assets.addFile("sweetsyntax.min.js", config.getPath("/../dist/sweetsyntax.min.js"))
    assets.addFile("logo.png", config.getPath("/logo.png"))
    assets.addFile("sweetworker.js", config.getPath("/sweetworker.js"))
    return assets

proc init*[T: typedesc[Configurator]](config: T): tuple[status: bool, instance: Configurator] =
    let configFilePath = getCurrentDir() & "/" & configFile
    if not fileExists(configFilePath):
        display("👉 Could not found a \"madam.yml\" in your project.", indent=4, br="before")
        display("Generate by `madam init` command", indent=4)
        quit()

    let doc = Nyml(engine: Y2J).parse(readFile(configFilePath))
    var
        routesTable = Router.init()
        assetsTable = Assets.init()
        configurator = Configurator(
            name: doc.get("name").getStr(),
            path: doc.get("path").getStr(),
            port: doc.get("port").getInt(),
            templates: (
                layouts: doc.get("templates.layouts").getStr(),
                views: doc.get("templates.views").getStr(),
                partials: doc.get("templates.partials").getStr()
            )
        )

    configurator.routes = configurator.collectRoutes(routesTable, doc.get("routes"))
    configurator.assets = configurator.collectAssets(assetsTable, doc.get("assets"))

    return (status: true, instance: configurator)