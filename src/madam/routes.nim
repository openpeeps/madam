import std/[tables, strutils]
from std/httpcore import HttpMethod
from std/strutils import replace, toUpperAscii

export tables, HttpMethod

type
  RouteTable = Table[string, Route]
  
  Router* = object
    head, get, post, put, delete, trace,
      options, connect, patch: RouteTable
  RouteType* = enum
    rtRoute
    rtEndpoint

  Route = object
    verb: HttpMethod
    route: string
    case `type`: RouteType
    of rtRoute:
      file: string
    of rtEndpoint: discard # todo

proc init*[R: Router](router: typedesc[R]): R =
  ## Initialize a new Router object
  result = Router(
    head: initTable[string, Route](),
    get: initTable[string, Route](),
    post: initTable[string, Route](),
    put: initTable[string, Route](),
    delete: initTable[string, Route](),
    trace: initTable[string, Route](),
    options: initTable[string, Route](),
    connect: initTable[string, Route](),
    patch: initTable[string, Route]()
  )

proc getRouteMethod(router: Router, verb: HttpMethod): RouteTable =
  # Retrieve a immutable version of Route object by verb and key
  result = case verb:
    of HttpHead: router.head
    of HttpGet: router.get
    of HttpPost: router.post
    of HttpPut: router.put
    of HttpDelete: router.delete
    of HttpTrace: router.trace
    of HttpOptions: router.options
    of HttpConnect: router.connect
    else: router.patch

proc getRouteMethodByStr(verb: string): HttpMethod =
  result = case verb.toUpperAscii:
            of "HEAD": HttpHead
            of "GET": HttpGet
            of "POST": HttpPost
            of "PUT": HttpPut
            of "DELETE": HttpDelete
            of "TRACE": HttpTrace
            of "OPTIONS": HttpOptions
            of "CONNECT": HttpConnect
            else: HttpPatch

proc exists*(router: Router, verb: HttpMethod, k: string, existsGet = false): bool =
  ## Determine if a route exists based on given verb and route key
  let routes = router.getRouteMethod(verb)
  let routeKey = if k.startsWith("/"): k[1 .. ^1] else: k
  result =  routes.hasKey(routeKey)

proc headExists*(r: Router, k: string): bool    = r.exists(HttpHead, k)
proc getExists*(r: Router, k: string): bool     = r.exists(HttpGet, k)
proc postExists*(r: Router, k: string): bool    = r.exists(HttpPost, k)
proc putExists*(r: Router, k: string): bool     = r.exists(HttpPut, k)
proc deleteExists*(r: Router, k: string): bool  = r.exists(HttpDelete, k)
proc traceExists*(r: Router, k: string): bool   = r.exists(HttpTrace, k)
proc optionsExists*(r: Router, k: string): bool = r.exists(HttpOptions, k)
proc connectExists*(r: Router, k: string): bool = r.exists(HttpConnect, k)
proc patchExists*(r: Router, k: string): bool   = r.exists(HttpPatch, k)

proc getRoute*(r: Router, verb: HttpMethod, k: string): Route =
  ## Retrieve a Route object by verb and key
  let routes = r.getRouteMethod(verb)
  let routeKey = if k.startsWith("/"): k[1 .. ^1] else: k
  result = routes[routeKey]

proc newRoute(r: var Router, routeType: RouteType,  v: HttpMethod, k, f = "") =
  if not r.exists(v, k):
    case v:
    of HttpHead: r.head[k]       = Route(verb: v, route: k, `type`: rtRoute)
    of HttpGet:
      r.get[k] = Route(verb: v, route: k, `type`: routeType)
      r.get[k].file = f
    of HttpPost: r.post[k]       = Route(verb: v, route: k, `type`: rtRoute)
    of HttpPut: r.put[k]         = Route(verb: v, route: k, `type`: rtRoute)
    of HttpDelete: r.delete[k]   = Route(verb: v, route: k, `type`: rtRoute)
    of HttpTrace: r.trace[k]     = Route(verb: v, route: k, `type`: rtRoute)
    of HttpOptions: r.options[k] = Route(verb: v, route: k, `type`: rtRoute)
    of HttpConnect: r.connect[k] = Route(verb: v, route: k, `type`: rtRoute)
    of HttpPatch: r.patch[k]     = Route(verb: v, route: k, `type`: rtRoute)

proc addRoute*(r: var Router, verb, k: string, f = "") =
  r.newRoute(rtRoute, getRouteMethodByStr(verb), k, f)

proc getFile*(r: Route): string =
  ## Return the file of the current Route object
  return r.file
