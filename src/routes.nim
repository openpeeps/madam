# Madam 💋 A lightweight local web server for
# Design Prototyping 🎨 and Front-end Development 🌈
# 
# MIT License
# Copyright (c) 2022 George Lemon from OpenPeep
# https://github.com/openpeep/madam

import std/tables
from std/httpcore import HttpMethod
from std/strutils import replace, toUpperAscii
export tables

type
    RouteTable = Table[string, Route]
    
    Router* = object
        head, get, post, put, delete, trace, options, connect, patch: RouteTable

    Route = object
        verb: HttpMethod                    # Covers all HTTP Methods. https://nim-lang.org/docs/httpcore.html#HttpMethod
        route: string
        file: string

proc init*[T: typedesc[Router]](router: T): Router =
    ## Initialize a new Router object
    return Router(
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

proc getRouteMethod[T: Router](router: T, verb: HttpMethod): RouteTable =
    ## Retrieve a immutable version of Route object by verb and key
    return case verb:
        of HttpHead: router.head
        of HttpGet: router.get
        of HttpPost: router.post
        of HttpPut: router.put
        of HttpDelete: router.delete
        of HttpTrace: router.trace
        of HttpOptions: router.options
        of HttpConnect: router.connect
        of HttpPatch: router.patch

proc getRouteMethodByStr(verb: string): HttpMethod =
    case verb.toUpperAscii:
        of "HEAD": result = HttpHead
        of "GET": result = HttpGet
        of "POST": result = HttpPost
        of "PUT": result = HttpPut
        of "DELETE": result = HttpDelete
        of "TRACE": result = HttpTrace
        of "OPTIONS": result = HttpOptions
        of "CONNECT": result = HttpConnect
        of "PATCH": result = HttpPatch
    return result

proc exists*[T: Router](router: T, verb: HttpMethod, k: string, existsGet = false): bool =
    ## Determine if a route exists based on given verb and route key
    let routes = router.getRouteMethod(verb)
    let routeKey = if k.startsWith("/"): k[1 .. ^1] else: k
    return routes.hasKey(routeKey)

proc headExists*[T: Router](r: T, k: string): bool    = r.exists(HttpHead, k)
proc getExists*[T: Router](r: T, k: string): bool     = r.exists(HttpGet, k)
proc postExists*[T: Router](r: T, k: string): bool    = r.exists(HttpPost, k)
proc putExists*[T: Router](r: T, k: string): bool     = r.exists(HttpPut, k)
proc deleteExists*[T: Router](r: T, k: string): bool  = r.exists(HttpDelete, k)
proc traceExists*[T: Router](r: T, k: string): bool   = r.exists(HttpTrace, k)
proc optionsExists*[T: Router](r: T, k: string): bool = r.exists(HttpOptions, k)
proc connectExists*[T: Router](r: T, k: string): bool = r.exists(HttpConnect, k)
proc patchExists*[T: Router](r: T, k: string): bool   = r.exists(HttpPatch, k)

proc getRoute*[T: Router](router: T, verb: HttpMethod, k: string): Route =
    ## Retrieve a Route object by verb and key
    let routes = router.getRouteMethod(verb)
    let routeKey = if k.startsWith("/"): k[1 .. ^1] else: k
    return routes[routeKey]

proc newRoute[T: Router](r: var T, v: HttpMethod, k, f = "") =
    if not r.exists(v, k):
        case v:
        of HttpHead: r.head[k]       = Route(verb: v, route: k)
        of HttpGet: r.get[k]         = Route(verb: v, route: k, file: f)
        of HttpPost: r.post[k]       = Route(verb: v, route: k)
        of HttpPut: r.put[k]         = Route(verb: v, route: k)
        of HttpDelete: r.delete[k]   = Route(verb: v, route: k)
        of HttpTrace: r.trace[k]     = Route(verb: v, route: k)
        of HttpOptions: r.options[k] = Route(verb: v, route: k)
        of HttpConnect: r.connect[k] = Route(verb: v, route: k)
        of HttpPatch: r.patch[k]     = Route(verb: v, route: k)

proc addRoute*[T: Router](r: var T, verb, k: string, f:string = "") =
    r.newRoute(getRouteMethodByStr(verb), k, f)

proc getFile*[T: Route](route: T): string =
    ## Return the file of the current Route object
    return route.file
