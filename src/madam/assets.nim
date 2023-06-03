import std/[os, tables, strutils]
import kapsis/cli

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

proc hasFile*[T: Assets](assets: T, alias: string): bool =
  ## Determine if requested file exists
  if assets.files.hasKey(alias):
    return fileExists(assets.files[alias].path)
  return false

proc addFile*[T: Assets](assets: var T, alias, path: string) =
  ## Add a new File object to Assets collection
  if not assets.hasFile(alias):
    assets.files[alias] = File(alias: alias, path: normalizedPath(path))

proc getFile*[T: Assets](assets: T, alias: string): string =
  ## Retrieve the contents of requested file
  return readFile(assets.files[alias].path)