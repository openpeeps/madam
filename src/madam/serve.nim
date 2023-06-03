import httpx
import std/[options, asyncdispatch]
import ./assets, ./configurator, ./routes, ./defaults

from std/os import getCurrentDir, fileExists, execShellCmd
from std/strutils import `%`, startsWith, replace
from kapsis/cli import display

type
  Logger = object
    code: HttpCode
    verb: HttpMethod
    path: string

  ResponseTuple = tuple[code: HttpCode, body: string]

proc httpGetRequest(route: string, config: Configurator): ResponseTuple =
  # Procedure for handling GET Requests for public routes and static assets
  let assetsEndpoint = "/assets/"
  var path = route
  var response = (code: Http404, body: defaults.getErrorPage)
  case path
  of "/":
    if config.hasClearOutput(): discard execShellCmd("clear")
    let indexFilePath = config.getViewsPath("index.html")
    if fileExists(indexFilePath):
      response = (code: Http200, body: readFile(indexFilePath))
    else:
      response = (code: Http200, body: defaults.getWelcomeScreen)
  else:
    if path.startsWith(assetsEndpoint):
      path = replace(path, assetsEndpoint)
      if config.getAssets().hasFile(path):
        response = (code: Http200, body: config.getAssets().getFile(path))
    elif getExists(config.routes, path):
      if config.hasClearOutput(): discard execShellCmd("clear")
      let routeObject = getRoute(config.routes, HttpGet, path)
      if fileExists(routeObject.getFile()):
        response = (code: Http200, body: readFile(routeObject.getFile()))
  return response

proc httpPostRequests(route: string, config: Configurator, body: string): ResponseTuple =
  ## Handle POST requests
  var response = (code: Http404, body: "{\"message\": \"Page not found\"}")
  if postExists(config.routes, route):
    response = (code: Http200, body: "{\"response\": $1}" % [body])
  return response

proc httpPutRequests(route: string, config: Configurator): ResponseTuple =
  ## Handle PUT requests and returns status code and body (if needed):
  ## Status 204 - No Content:     Update to an existing resource (no body)
  ## Status 201 - Created:        Successful PUT of a new resource (includes body)
  ## Status 409 - Conflict:       Unsuccessful submission modification, listing diff between the attempted and the current resource (includes body)
  ## Status 400 - Bad Request:    Unsuccessful PUT (includes body)
  return (code: Http204, body: "")

proc httpConnectRequests(route: string, config: Configurator): tuple[code: HttpCode, body: string] =
  ## Handle CONNECT requests. This Method requires --threads:on
  ## as it creates a new thread for each connection
  return (code: Http200, body: "Connection Established")

proc startHttpServer*(config: Configurator) =
  ## Start a Madam Server instance using current configuration
  let
    currentProject = getCurrentDir()
    localAddress = "127.0.0.1"

  proc onRequest(req: Request): Future[void] =
    let path = req.path.get()
    var logger = Logger()
    var response: ResponseTuple

    # Handle GET requests
    if req.httpMethod == some(HttpGet):
      response = httpGetRequest(path, config)

    # Handle POST requests
    elif req.httpMethod == some(HttpPost):
      response = httpPostRequests(path, config, req.body.get())

    # Handle PUT requests
    elif req.httpMethod == some(HttpPut):
      response = httpPutRequests(path, config)

    # TODO
    # Handle CONNECT requests
    # elif req.httpMethod == some(HttpConnect):
    #     response = httpConnectRequests(path, config)

    # Collect request / response via Logger
    logger.code = response.code
    logger.verb = req.httpMethod.get()
    logger.path = path

    # Send the response. If enabled, prompt to console
    # all requests, including HTTP Method, Status Code, and path
    req.send(response.code, response.body)
    if config.hasLogger():
      display("$1 $2  ➤  $3" % [$logger.verb, $logger.code, logger.path], indent=2)
  run(onRequest, initSettings(port=Port(config.getPort()), bindAddr=localAddress))
