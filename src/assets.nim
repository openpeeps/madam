# Madam 💋 A lightweight local web server for
# Design Prototyping 🎨 and Front-end Development 🌈
# 
# GPLv3 License
# Copyright (c) 2022 George Lemon from OpenPeep
# https://github.com/openpeep/madam

import std/tables
from std/os import fileExists, getCurrentDir
export tables

type
    Assets* = object
        files: Table[string, File]

    File = object
        alias, path: string

proc init*[T: typedesc[Assets]](assets: T): Assets =
    ## Initialize a new Assets object collection
    return assets(files: initTable[string, File]())

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