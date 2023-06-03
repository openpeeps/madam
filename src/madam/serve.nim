import httpx, emitter, jsony, pkginfo
import std/[options, asyncdispatch, tables, strutils, macros, httpcore]
import ./assets, ./configurator, ./routes, ./defaults

from std/os import getCurrentDir, fileExists, execShellCmd
from std/strutils import `%`, startsWith, replace
from kapsis/cli import display

type
  Logger = object
    code: HttpCode
    verb: HttpMethod
    path: string

  EndpointType = enum
    etRoot = "root"
    etSection = "section"

  Endpoint = ref object
    case `type`: EndpointType
      of etRoot:
        version: string
        endpoints: Table[string, Endpoint] # a table containing dynamic generated endpoints
      else:
        url: string
    
  ResponseTuple = tuple[code: HttpCode, body: string]

proc `$$`(h: HttpHeaders): string =
  for k, values in h.table:
    add result, k & ":"
    for v in values:
      add result, v & ";"

proc getRootEndpoint(path: string): string =
  # template getHomeEndpoint(v: string) =

  macro rootpoint() =
    let v = $(pkg().getVersion)
    result = newStmtList()
    result.add quote do:
      let ep = Endpoint(type: etRoot, version: `v`)
      return ep.toJson
  rootpoint()

proc getEndpoint(path: string): string =
  let ep = Endpoint(`type`: etRoot, version: "0.1.0")
  result = ep.toJson()

proc httpGetRequest(req: Request, route: string, config: Config): HttpCode =
  # Handle `GET` requests
  let assetsEndpoint = "/assets/"
  var
    path = route
    code: HttpCode
    body: string
    headers = newHttpHeaders()
  case path
  of "/":
    if config.useClear:
      discard execShellCmd("clear")
    let indexFilePath = config.getViewsPath("index.html")
    if fileExists(indexFilePath):
      code = Http200
      body = readFile(indexFilePath)
    else:
      code = Http200
      body = defaults.getWelcomeScreen
  else:
    if path.startsWith assetsEndpoint:
      path = replace(path, assetsEndpoint)
      if config.getAssets.hasFile path:
        code = Http200
        body = config.getAssets.getFile(path)
    elif path.startsWith "/madam":
      headers.add("content-type", "application/json")
      code = Http200
      body = getRootEndpoint(path)
    elif path.startsWith "/api":
      headers.add("content-type", "application/json")
      code = Http200
      body = getEndpoint(path)
    elif getExists(config.routes, path):
      if config.useClear:
        discard execShellCmd("clear")
      let routeObject = getRoute(config.routes, HttpGet, path)
      if fileExists(routeObject.getFile):
        code = Http200
        body = readFile(routeObject.getFile)
    else:
      code = Http404
      body = defaults.getErrorPage
  headers.add("content-type", "charset=utf-8")
  req.send(code, body, headers = $$headers)
  result = code

proc httpPostRequests(req: Request, route: string, config: Config, body: string): HttpCode =
  ## Handle POST requests
  if postExists(config.routes, route):
    result = Http200
    req.send(result, "{\"response\": $1}" % [body])
  else:
    result = Http404
    req.send(result, "{\"message\": \"Page not found\"}")

proc httpPutRequests(req: Request, route: string, config: Config): HttpCode =
  ## Handle PUT requests and returns status code and body (if needed):
  ## Status 204 - No Content:     Update to an existing resource (no body)
  ## Status 201 - Created:        Successful PUT of a new resource (includes body)
  ## Status 409 - Conflict:       Unsuccessful submission modification, listing diff between the
  ##                              attempted and the current resource (includes body)
  ## Status 400 - Bad Request:    Unsuccessful PUT (includes body)
  req.send(Http204, "")
  result = Http204

proc httpConnectRequests(route: string, config: Config): HttpCode =
  ## Handle CONNECT requests.
  # return (code: Http200, body: "Connection Established")
  result = Http200

proc startHttpServer*(config: Config) =
  ## Start a Madam Server instance using current configuration
  let
    currentProject = getCurrentDir()
    localAddress = "127.0.0.1"
  proc onRequest(req: Request): Future[void] =
    let path = req.path.get()
    var logger = Logger()
    case req.httpMethod.get
    of HttpGet:   # Handle GET requests
      logger.code = req.httpGetRequest(path, config)
    of HttpPost:  # Handle POST requests
      logger.code = req.httpPostRequests(path, config, req.body.get())
    of HttpPut:   # Handle PUT requests
      logger.code = req.httpPutRequests(path, config)
    else: discard # todo
    # Collect request / response via Logger
    logger.verb = req.httpMethod.get()
    logger.path = path

    if config.useLogger:
      display("$1 $2  ➤  $3" % [$logger.verb, $logger.code, logger.path], indent=2)
  run(onRequest, initSettings(port=Port(config.getPort()), bindAddr=localAddress))
