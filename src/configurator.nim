import nyml
from std/os import getCurrentDir, fileExists, normalizePath, splitFile
from std/strutils import `%`, replace
import ./assets
from klymene/cli import display

const configFile = "madam.yml"

type
    Configurator* = object
        name: string
        path: string
        port: int
        routes: RoutesTable
        assets: Assets

    RoutesTable = Table[string, string]

proc getName*[T: Configurator](config: T): string =
    return config.name

proc getPath*[T: Configurator](config: T, appendPath: string): string =
    ## Return the current project path
    var filepath = getCurrentDir() & "/" & config.path & appendPath
    filepath.normalizePath()
    return filepath

proc getPort*[T: Configurator](config: T): int =
    return config.port

proc getRoutes*[T: Configurator](config: T): RoutesTable =
    return config.routes

proc getAssets*[T: Configurator](config: T): Assets =
    return config.assets

proc collectRoutes[A: Configurator, B: RoutesTable](config: var A, table: var B, routes: JsonNode): B =
    for route, file in routes.pairs():
        let
            fileName = file.getStr
            filePath = config.getPath("/pages/" & fileName)
        if not filePath.fileExists():
            display("👉 \"$1\" file could not be found. (ignored)" % [filename], indent=4)
        # elif mime.getMimetype(replace(filePath.splitFile().ext, ".", "")) != "text/html":
            # display("👉 \"$1\" file has a different extension. Only \".html\" or \".htm\" allowed. (ignored)" % [filename], indent=4)
        else: table[route] = filePath
    return table

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
        routesTable: RoutesTable
        assetsTable = Assets.init()
        configurator = Configurator(
            name: doc.get("name").getStr(),
            path: doc.get("path").getStr(),
            port: doc.get("port").getInt(),
        )

    configurator.routes = configurator.collectRoutes(routesTable, doc.get("routes"))
    configurator.assets = configurator.collectAssets(assetsTable, doc.get("assets"))

    return (status: true, instance: configurator)