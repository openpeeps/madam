# Madam 💋 A lightweight local web server for
# Design Prototyping 🎨 and Front-end Development 🌈
# 
# GPLv3 License
# Copyright (c) 2022 George Lemon from OpenPeep
# https://github.com/openpeep/madam

import nyml
from std/os import getCurrentDir, fileExists, dirExists, normalizePath, splitFile, splitPath
from std/strutils import `%`, replace
import ./assets, ./routes
from klymene/cli import display

const configFile = "madam.yml"

type
    Configurator* = object
        name: string
        path: string
        port: int
        logger: bool
        templates: tuple[layouts, views, partials: string]
        routes*: Router
        assets: Assets
        assets_paths: tuple[source: string, public: string]

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
    result = config.getPath(dirpath & "/" & filePath)

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
proc hasEnabledLogger*[T: Configurator](config: T): bool = config.logger

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
    let files = finder(findArgs = @["-type", "f", "-print"], path = config.assets_paths.source)
    if files.len == 0: quit()
    for file in files:
        let f = splitPath(file)
        assets.addFile(f.tail, file)
    return assets

proc init*[T: typedesc[Configurator]](config: T): tuple[status: bool, instance: Configurator] =
    let configFilePath = getCurrentDir() & "/" & configFile
    if not fileExists(configFilePath):
        display("👉 Missing \"$1\" in your project." % [configFile], indent=2, br="before")
        display("Generate your config with \"madam init\"", indent=2)
        quit()
    
    let doc = Nyml(engine: Y2J).parse(readFile(configFilePath),
        rules = @["name*:string", "path*:string", "port:int|1234", "logs:bool|false",
                  "templates*:object", "templates.layouts*:string",
                  "templates.views*:string", "templates.partials*:string"])
    if doc.hasErrorRules():
        let count = doc.getErrorsCount()
        let errorWord = if count == 1: "error" else: "errors"
        display("👉 Found $1 $2 in your Madam configuration:" % [$doc.getErrorsCount(), errorWord], indent=2)
        for key, err in doc.getErrorRules().pairs():
            display("• " & err.getErrorMessage(), indent=2)
        quit()

    let
        layouts_path = doc.get("templates.layouts").getStr
        views_path = doc.get("templates.views").getStr
        partials_path = doc.get("templates.partials").getStr
    
    var
        RoutesObject = Router.init()
        AssetsObject = Assets.init()
        assets_source_path = getCurrentDir() & "/" & doc.get("assets.source").getStr
        config = Configurator(
            name: doc.get("name").getStr(),
            path: doc.get("path").getStr(),
            port: doc.get("port").getInt(),
            logger: doc.get("console.logger").getBool(),
            templates: (
                layouts: layouts_path,
                views: views_path,
                partials: partials_path
            ),
            assets_paths: (source: assets_source_path , public: getStr(doc.get("assets.public")))
        )

    # Check if layouts, views and partials directories exists
    for dir in @[config.getLayoutsPath(), config.getViewsPath(), config.getPartialsPath()]:
        if not dirExists(dir):
            display("👉 \"$1\" directory is missing" % [dir.splitPath.tail], indent=2)

    AssetsObject.assets_paths = config.assets_paths
    config.routes = config.collectRoutes(RoutesObject, doc.get("routes"))
    config.assets = config.collectAssets(AssetsObject, doc.get("assets"))

    return (status: true, instance: config)