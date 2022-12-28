# Madam 💋 A lightweight local web server for
# Design Prototyping 🎨 and Front-end Development 🌈
# 
# MIT License
# Copyright (c) 2022 George Lemon from OpenPeep
# https://github.com/openpeep/madam

import ../serve
import klymene/cli
import klymene/util
import ../configurator
from strutils import `%`
from std/os import sleep

proc runCommand*() =
    let Config = Configurator.init()
    let port = Config.instance.getPort()
    if Config.status == true:
        display("------------------------------------------------", indent=2, br="before")
        display("💃 Madam is dancing on http://$1:$2" % ["localhost", $port], indent=4)
        display("------------------------------------------------", indent=2, br="after")
        # display("Registered routes:", indent=2)
        # TODO list all registered routes as [VERB]  route  entry.html
        sleep(200)
        discard cmd("open", ["http://localhost:" & $port])
        try:
            startHttpServer(Config.instance)
        except OSError:
            echo getCurrentExceptionMsg()

    else:
        display("👉 Could not start a server on $1:$2" % ["localhost", $port], indent=4)