# Madam 💋 A lightweight local web server for
# Design Prototyping 🎨 and Front-end Development 🌈
# 
# GPLv3 License
# Copyright (c) 2022 George Lemon from OpenPeep
# https://github.com/openpeep/madam

import std/tables
import klymene/util
from std/os import fileExists, getCurrentDir
from klymene/cli import display
from std/strutils import strip, split
export tables

type
    Assets* = object
        assets_paths*: tuple[source: string, public: string]
        files: Table[string, File]

    File = object
        alias, path: string

proc init*[T: typedesc[Assets]](assets: T): Assets =
    ## Initialize a new Assets object collection
    return assets(files: initTable[string, File]())

proc finder*(findArgs: seq[string] = @[], path=""): seq[string] {.thread.} =
    ## Simple file system procedure that discovers static files in a specific directory
    var args: seq[string] = findArgs
    args.insert(path, 0)
    var files = cmd("find", args).strip()
    if files.len == 0:
        display("Unable to find any static files.", indent=2)
    else:
        return files.split("\n")

proc hasFile*[T: Assets](assets: T, alias: string): bool =
    ## Determine if requested file exists
    if assets.files.hasKey(alias):
        return fileExists(assets.files[alias].path)
    return false

proc addFile*[T: Assets](assets: var T, alias, path: string) =
    ## Add a new File object to Assets collection
    if not assets.hasFile(alias):
        assets.files[alias] = File(alias: alias, path: path)

proc getFile*[T: Assets](assets: T, alias: string): string =
    ## Retrieve the contents of requested file
    return readFile(assets.files[alias].path)