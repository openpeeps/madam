import nyml, kapsis/cli
import std/[strutils, os, osproc]
import ./assets, ./routes

const configFile = "madam.yml"

type
  Config* = object
    name: string
    path: string
    port: int
    logger: bool
    routes*: Router
    assets: Assets
    assets_paths: tuple[source, public: string]
    console: tuple[browser, logger, clear: bool]

proc finder*(args: varargs[string]): seq[string] =
  ## Simple file system procedure that discovers static files in a specific directory
  let cmd = execCmdEx("find" & indent(args.join(" "), 1))
  if cmd.exitCode == 0:
    var files = cmd.output.strip()
    if files.len == 0:
      display("Unable to find any static files.", indent=2)
    else:
      return files.split("\n")

proc getName*(config: Config): string =
  return config.name

proc getPath*(config: Config, path: string): string =
  ## Return the current project path
  var filepath = getCurrentDir() & "/" & config.path
  filepath = if path.len != 0: (filepath & "/" & path) else: filepath
  filepath.normalizePath()
  return filepath

proc getTemplatesPath(config: Config, dir: string, filePath: string): string =
  ## Get absolute path from current project
  result = config.getPath(dir & filePath)

proc getViewsPath*(config: Config, path: string = ""): string =
  ## Get the path that points to views directory
  return config.getTemplatesPath("views", "/" & path)

proc getLayoutsPath*(config: Config, path: string = ""): string =
  ## Get the path that points to layouts directory
  return config.getTemplatesPath("layouts", "/" & path)

proc getPartialsPath*(config: Config, path: string = ""): string =
  ## Get the path that points to partials directory
  return config.getTemplatesPath("partials", "/" & path)

proc getPort*(config: Config): int = config.port

proc useBrowser*(config: Config): bool = config.console.browser
proc useLogger*(config: Config): bool = config.console.logger
proc useClear*(config: Config): bool = config.console.clear

proc getAssets*(config: Config): Assets =
  return config.assets

proc getAssetsPath*(config: Config): tuple[source: string, public: string] = config.assets_paths

proc collectRoutes[A: Config, B: Router](config: var A, router: var B, routes, endpoints: JsonNode): B =
  if routes != nil:
    for verb in routes.keys:
      for route, file in routes[verb].pairs:
        let fileName = file.getStr
        let filePath = config.getViewsPath(fileName)
        if verb == "get":
          # TODO check file type via mimetypes
          if filePath.fileExists():
            router.addRoute(verb, route, filePath)
          else: 
            display("👉 \"$1\" not found. (ignored)" % [filename], indent=2)
        else: router.addRoute(verb, route)
  # todo
  # if endpoints != nil: # register endpoints for /api
  #   for verb in endpoints.keys:
  #     for k, route in endpoints[verb].pairs:
  result = router

proc collectAssets[A: Config, B: Assets](config: var A, assets: var B, assetsNode: JsonNode): B =
  ## Collect all static files inside assets directory
  let files = finder(config.assets_paths.source, "-type f -print")
  for file in files:
    let f = splitPath(file)
    assets.addFile(f.tail, file)
  return assets

proc newConfig*(): tuple[status: bool, instance: Config] =
  ## Initialize Madam Config for current project
  let configFilePath = getCurrentDir() & "/" & configFile
  if not fileExists(configFilePath):
    display("👉 Missing \"$1\" in your project." % [configFile], indent=2, br="before")
    display("Generate your config with \"madam init\"", indent=2)
    quit()
  
  var yml = yaml(readFile(configFilePath))
  # let doc = yml.toJson(rules = @[
  #     "name*:string",
  #     "path*:string",
  #     "port:int|1234",
  #     "templates*:object"
  # ])
  let doc = yml.toJson()

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
    routesInstance = Router.init()
    assetsInstance = Assets.init()
    assets_source_path = getCurrentDir() & "/" & doc.get("assets.source").getStr
    config = Config(
      name: doc.get("name").getStr,
      path: doc.get("path").getStr,
      port: doc.get("port").getInt,
      assets_paths: (
        source: assets_source_path,
        public: doc.get("assets.public").getStr
      ),
      console: (
        browser: doc.get("console.open-browser").getBool,
        logger: doc.get("console.cli-logger").getBool,
        clear: doc.get("console.cli-clear").getBool
      )
    )

  assetsInstance.assets_paths = config.assets_paths
  config.routes = config.collectRoutes(routesInstance, doc.get("routes"), doc.get("api"))
  config.assets = config.collectAssets(assetsInstance, doc.get("assets"))

  return (status: true, instance: config)