import nyml
import std/tables
from std/os import getCurrentDir, fileExists
from std/asyncdispatch import Port

const configFile = "madam.yml"

type
    Configurator* = object
        name: string
        path: string
        port: Port
        routes: RoutesTable
        assets: AssetsTable

    RoutesTable = Table[string, string]
    AssetsTable = Table[string, string]

proc collectRoutes[T: RoutesTable](table: var T, routes: JsonNode): RoutesTable =
    discard

proc collectAssets[T: AssetsTable](table: var T, assets: JsonNode): AssetsTable =
    discard

proc init*[T: typedesc[Configurator]](config: T): tuple[status: bool, config: Configurator] =
    let madamConfigPath = getCurrentDir() & configFile
    if not fileExists(getCurrentDir() & configFile):
        echo "Could not found a `madam.yml` in your root project."

    let doc = Nyml(engine: Y2J).parse(readFile(madamConfigPath))
    
    var routesTable: RoutesTable
    var assetsTable: AssetsTable

    return (status: true, config: Configurator(
        name: doc.get("name").strValue,
        path: doc.get("name").strValue,
        port: Port(doc.get("port").intValue),
        routes: routesTable.generateRoutes(doc.get("routes")),
        assets: assetsTable.generateAssets(doc.get("assets"))
    ))

proc getName*[T: Configurator](config: T): string =
    return config.name

proc getPath*[T: Configurator](config: T): string =
    return config.path

proc getPort*[T: Configurator](config: T): Port =
    return config.port

proc getRoutes*[T: Configurator](config: T): RoutesTable =
    return config.routes

proc getAssets*[T: Configurator](config: T): AssetsTable =
    return config.assets