import std/os
export os

type
    OS = enum
        Linux = "GNU Linux"
        Windows = "Microsoft Linux"
        OSX = "Apple OS X"

proc getCurrentOS*(): string =
    var currsys: OS
    if defined(linux):     currsys = Linux
    elif defined(windows): currsys = Windows
    elif defined(macosx):  currsys = OSX
    return $currsys

proc messagesFileExists*(): bool {.inline.} = fileExists(getCurrentDir() & "/src/messages.nim")