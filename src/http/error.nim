# Madam 💋 A lightweight local web server for
# Design Prototyping 🎨 and Front-end Development 🌈
# 
# MIT License
# Copyright (c) 2022 George Lemon from OpenPeep
# https://github.com/openpeep/madam

from strutils import `%`

const getErrorPage* = """<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$2 | $3 &mdash; $1</title>
    <style>
        :root {
            --madam-ff: system-ui,-apple-system,"Segoe UI",Roboto,"Helvetica Neue",Arial,"Noto Sans","Liberation Sans",sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol","Noto Color Emoji";
            --madam-fs: 1.2rem;
        }
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }
    </style>
</head>
<body style="background-color: whitesmoke; font-family: var(--madam-ff); font-size: var(--madam-fs);">
    <div class="container" style="display: flex; height: 100vh; align-items: center;">
        <h2 style="font-weight: 400; width: 100%; text-align: center;">$2 | $3 &mdash; Madam</h2>
    </div>
</body>
</html>""" % ["Madam", "404", "Not Found"]