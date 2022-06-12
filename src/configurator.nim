# Madam 💋 A lightweight local web server for
# Design Prototyping 🎨 and Front-end Development 🌈
# 
# MIT License
# Copyright (c) 2022 George Lemon from OpenPeep
# https://github.com/openpeep/madam

import nyml, tim
import ./assets, ./routes

from std/os import getCurrentDir, fileExists, dirExists, normalizePath, splitFile, splitPath
from std/strutils import `%`, replace
from klymene/cli import display

const configFile = "madam.yml"

type
    Configurator* = object
        name: string
        path: string
        port: int
        logger: bool
        routes*: Router
        assets: Assets
        assets_paths: tuple[source, public: string]
        console: tuple[logger, clear: bool]

proc getName*[T: Configurator](config: T): string =
    return config.name

proc getPath*[T: Configurator](config: T, path: string): string =
    ## Return the current project path
    var filepath = getCurrentDir() & "/" & config.path
    filepath = if path.len != 0: (filepath & "/" & path) else: filepath
    filepath.normalizePath()
    return filepath

proc getTemplatesPath[T: Configurator](config: T, dir: string, filePath: string): string =
    ## Get absolute path from current project
    result = config.getPath(dir & filePath)

proc getViewsPath*[T: Configurator](config: T, path: string = ""): string =
    ## Get the path that points to views directory
    return config.getTemplatesPath("views", "/" & path)

proc getLayoutsPath*[T: Configurator](config: T, path: string = ""): string =
    ## Get the path that points to layouts directory
    return config.getTemplatesPath("layouts", "/" & path)

proc getPartialsPath*[T: Configurator](config: T, path: string = ""): string =
    ## Get the path that points to partials directory
    return config.getTemplatesPath("partials", "/" & path)

proc getPort*[T: Configurator](config: T): int = config.port
proc hasLogger*[T: Configurator](config: T): bool = config.console.logger
proc hasClearOutput*[T: COnfigurator](config: T): bool = config.console.clear == true

proc getAssets*[T: Configurator](config: T): Assets =
    return config.assets

proc getAssetsPath*[T: Configurator](config: T): tuple[source: string, public: string] = config.assets_paths

proc collectRoutes[A: Configurator, B: Router](config: var A, router: var B, routes: JsonNode): B =
    for verb in routes.keys():
        for route, file in routes[verb].pairs():
            let fileName = file.getStr
            let filePath = config.getViewsPath(fileName)
            if verb == "get":
                if not filePath.fileExists():
                    display("👉 \"$1\" file could not be found. (ignored)" % [filename], indent=2)
                    # TODO check file type via mimetypes
                else: router.addRoute(verb, route, filePath)
            else: router.addRoute(verb, route)
    return router

proc collectAssets[A: Configurator, B: Assets](config: var A, assets: var B, assetsNode: JsonNode): B =
    ## Collect all static files inside assets directory
    let files = finder(findArgs = @["-type", "f", "-print"], path = config.assets_paths.source)
    if files.len == 0: quit()
    for file in files:
        let f = splitPath(file)
        assets.addFile(f.tail, file)
    return assets

proc init*[T: typedesc[Configurator]](config: T): tuple[status: bool, instance: Configurator] =
    ## Initialize Madam Configurator for current project
    let configFilePath = getCurrentDir() & "/" & configFile
    if not fileExists(configFilePath):
        display("👉 Missing \"$1\" in your project." % [configFile], indent=2, br="before")
        display("Generate your config with \"madam init\"", indent=2)
        quit()
    
    var yml = Nyml.init(contents = readFile(configFilePath))
    let doc = yml.toJson(rules = @[
        "name*:string",
        "path*:string",
        "port:int|1234",
        "templates*:object"
    ])

    # TODO on Nyml
    # if doc.hasErrorRules():
    #     let count = doc.getErrorsCount()
    #     let errorWord = if count == 1: "error" else: "errors"
    #     display("👉 Found $1 $2 in your Madam configuration:" % [$doc.getErrorsCount(), errorWord], indent=2)
    #     for key, err in doc.getErrorRules().pairs():
    #         display("• " & err.getErrorMessage(), indent=2)
    #     quit()

    let
        layouts_path = doc.get("templates.layouts").getStr
        views_path = doc.get("templates.views").getStr
        partials_path = doc.get("templates.partials").getStr

    # TODO
    # var engine = TimEngine.init(
    #         source = doc.get("path").getStr,
    #         output = doc.get("path").getStr & "/storage/templates",
    #         hotreload = false)

    var
        RoutesObject = Router.init()
        AssetsObject = Assets.init()
        assets_source_path = getCurrentDir() & "/" & doc.get("assets.source").getStr
        config = Configurator(
            name: doc.get("name").getStr,
            path: doc.get("path").getStr,
            port: doc.get("port").getInt,
            assets_paths: (
                source: assets_source_path,
                public: doc.get("assets.public").getStr
            ),
            console: (
                logger: doc.get("console.logger").getBool,
                clear: doc.get("console.clear").getBool
            )
        )

    AssetsObject.assets_paths = config.assets_paths
    config.routes = config.collectRoutes(RoutesObject, doc.get("routes"))
    config.assets = config.collectAssets(AssetsObject, doc.get("assets"))

    return (status: true, instance: config)