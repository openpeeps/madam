# Madam 💋 A lightweight local web server for
# Design Prototyping 🎨 and Front-end Development 🌈
# 
# MIT License
# Copyright (c) 2022 George Lemon from OpenPeep
# https://github.com/openpeep/madam

import std/tables
from std/httpcore import HttpMethod
from std/strutils import replace
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

proc exists*[T: Router](router: T, verb: HttpMethod, key: string, existsGet = false): bool =
    ## Determine if a route exists based on given verb and route key
    let routes = case verb:
    of HttpHead: router.head
    of HttpGet: router.get
    of HttpPost: router.post
    of HttpPut: router.put
    of HttpDelete: router.delete
    of HttpTrace: router.trace
    of HttpOptions: router.options
    of HttpConnect: router.connect
    of HttpPatch: router.patch
    let routeKey = if key.startsWith("/"): key[1 .. ^1] else: key
    return routes.hasKey(routeKey)

proc headExists*[T: Router](router: T, key: string): bool = router.exists(HttpHead, key)
proc getExists*[T: Router](router: T, key: string): bool = router.exists(HttpGet, key)
proc postExists*[T: Router](router: T, key: string): bool = router.exists(HttpPost, key)
proc putExists*[T: Router](router: T, key: string): bool = router.exists(HttpPut, key)

proc getRoute*[T: Router](router: T, verb: HttpMethod, key: string): Route =
    let routes = case verb:
    of HttpHead: router.head
    of HttpGet: router.get
    of HttpPost: router.get
    of HttpPut: router.put
    of HttpDelete: router.delete
    of HttpTrace: router.trace
    of HttpOptions: router.options
    of HttpConnect: router.connect
    of HttpPatch: router.patch
    let routeKey = if key.startsWith("/"): key[1 .. ^1] else: key
    return routes[routeKey]

proc addGet*[T: Router](router: var T, key, file: string) =
    ## Add a new route for GET Method
    if not router.exists(HttpGet, key):
        router.get[key] = Route(verb: HttpGet, route: key, file: file)

proc getFile*[T: Route](route: T): string =
    ## Return the file of the current Route object
    return route.file