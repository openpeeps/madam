# Madam 💋 A lightweight local web server for
# Design Prototyping 🎨 and Front-end Development 🌈
# 
# MIT License
# Copyright (c) 2022 George Lemon from OpenPeep
# https://github.com/openpeep/madam

import std/tables
from std/os import fileExists, getCurrentDir
from std/httpcore import HttpMethod
export tables

type
    Router* = object
        head, get, post, put, delete, trace, options, connect, patch: Table[string, Route]

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

proc exists*[T: Router](router: T, verb: HttpMethod, key: string): bool =
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
    return routes.hasKey(key)

proc get*[T: Router](router: var T, route, file: string) =
    ## Add a new route for GET Method
    if not router.exists(HttpGet, route):
        router.get[route] = Route(verb: HttpGet, route: route, file: file)
