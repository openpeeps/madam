<p align="center">
    <img src="https://github.com/openpeep/madam/raw/main/.github/madam.png" width="140px"><br><strong>Madam 💋 A lightweight local web server for Design Prototyping • Front-end Development 🌈</strong><br>Pew pew pew! ZWIFF! Boom!<br>
    <img src="https://github.com/openpeep/madam/raw/main/.github/carbon.png" width="603px">
</p>

<details>
    <summary align="center">👋 Madam Welcome Screen is sooo POP! 🙀</summary>
    <img src="https://github.com/openpeep/madam/raw/main/.github/welcomescreen.png" width="1200px" alt="Madam - Welcome screen"/>
</details>

## 😍 Key Features
- [x] Compiled, Fast, Low memory foot-print 🍃
- [x] < 1MB file size binary app
- [x] < 3MB RAM usage in Welcome Screen 🥳
- [x] Install once, run anytime, as many servers you need 👌
- [x] No code required
- [x] Serve Static Assets 📦
- [x] Configuration via `madam.yml`
- [ ] Static HTML Website Generator
- [x] Routes Management via `madam.routes.yml`
- [ ] Supports all HTTP verbs, `GET`, `POST`, `HEAD`, etc.
- [ ] Madam Skins / [Template Engine via Tim](https://github.com/openpeep/tim) for `layout`, `view`, `partials`
- [x] Made for **Design Prototyping** and **Front-end Development**
- [x] Works on **Linux** and **OS X**
- [x] Open Source under `MIT` license
- [x] Pew pew pew! ZWIFF! 💋

## Why ?
Because NodeJS environment sucks and there are no other lightweight / easy to setup alternatives.

## 🥳 Best for
Prototyping. Showcase. JavaScript, HTML, CSS projects, libraries or packages. Also best for testers and designers. Pew pew again!

## 💅 Installing
Madam is currently available for **OS X** and **Linux distributions** only. You can compile Madam by yourself, or get the latest version from [GitHub releases](https://github.com/openpeep/madam/releases).

Setup Madam to your `PATH` and do the do 🤓 Better said, do the blue! 😎
```zsh
ln -s ~/path/to/your/madam /usr/local/bin
```

## ✨ Madam Commands
```zsh
Madam 💋 A Lightweight & Fast Local Web Server for
Design Prototyping 🎨 and Front-end Development 🌈
👉 Info, updates and bugs: https://github.com/openpeep/madam

Usage:
   init                           Create a new Madam configuration file from CLI
   run [--verbose]                Run local server. Use verbose flag for tracking requests
   build                          Build current project to Static HTML Website

Options:
  -h --help                       Show this screen.
  -v --version                    Show Madam version.
```

## Developing with Madam
Run `madam init` in your project directory and setup your `madam.yml` via command line wizard.

Here you can find a beautiful `madam.yml` configuration that covers all Madam features.

On hold, Madam depends on 👉 [Nyml](https://github.com/openpeep/nyml) (WIP)

```yaml
name: "Awesome Madam"
path: "./example"                   # path to your root HTML project
port: 1230                          # optional | default 1010

# Paths for layouts, views or partials
# These paths are prepended with project path provided above
# For example, layouts will point to "./example/layouts"
templates:
    layouts: "layouts"              # directory path for layouts
    views: "views"                  # directory path for views
    partials: "partials"            # directory path for partials


routes:
    get:
        about: "about.html"
        products/my-product: "product.html"
        publish: "publish.html"

# Define your custom Middlewares
middlewares:
    auth: "@login.session"                                      # link to a session

# Setup Static Assets to serve any kind of static files via Madam
assets:
    source: "./dist/assets/*"        # Path on disk for indexing the static assets
    public: "/assets"                # Public route for accessing the static assets

# Customize console output
console:
    logger: true                    # Enable http request logger
    clear: true                     # Clear previous console output on request
```

## Madam Skins
The way you can stay **DRY**. Madam brings `layouts`, `views` and `partials` logic to your project.

On hold, Madam depends on 👉 [Tim Template Engine](https://github.com/openpeep/tim) (WIP)

### Create the first page
_todo_


## Roadmap
#### 0.1.0
- [x] Create logo
- [x] Embedding Httpbeast
- [x] Routes Handler
- [x] Static Assets Handler
- [x] `init` command
- [x] `run` command with `--verbose` flag
- [ ] `build` command
- [ ] Multi-threading while generating project to Static HTML
- [ ] Templating via [Tim Engine](https://github.com/openpeep/tim) supporting `layouts`, `views`, `partials`
- [ ] GitHub Workflow Action for [Cross Compilation and Release](https://github.com/nim-lang/Nim/wiki/BuildServices#8-cross-compilation-and-release)
- [ ] Talk about it on ycombinator / stackoverflow / producthunt 

#### 0.2.0
- [ ] Fake content generator based on [Faker Nim library](https://github.com/jiro4989/faker)

### 0.3.0
- [ ] Madam GUI

### ❤ Contributions
If you like this project you can contribute to Madam by opening new issues, fixing bugs, contribute with code, ideas and you can even [donate via PayPal address](https://www.paypal.com/donate/?hosted_button_id=RJK3ZTDWPL55C) 🥰

### 👑 Discover Nim language
<strong>What's Nim?</strong> Nim is a statically typed compiled systems programming language. It combines successful concepts from mature languages like Python, Ada and Modula. [Find out more about Nim language](https://nim-lang.org/)

<strong>Why Nim?</strong> Performance, fast compilation and C-like freedom. We want to keep code clean, readable, concise, and close to our intention. Also a very good language to learn in 2022.

### 🎩 License
Madam is an Open Source Software released under `MIT` license. [Developed by Humans from OpenPeep](https://github.com/openpeep).<br>
Copyright &copy; 2022 OpenPeep & Contributors &mdash; All rights reserved.

<a href="https://hetzner.cloud/?ref=Hm0mYGM9NxZ4"><img src="https://openpeep.ro/banners/openpeep-footer.png" width="100%"></a>
