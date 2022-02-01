<p align="center">This is Madame 💅 A simple and fast local web server for prototyping and front-end development</strong></p>

## 😍 Key Features
- [x] Compiled, Fast, Low memory foot-print 🍃
- [ ] Serve Static Assets 📦
- [ ] Configuration via `madam.yml`
- [ ] Routes Management via `madam.router.yml`
- [ ] Supports all HTTP verbs, `GET`, `POST`, `HEAD`, etc.
- [ ] Madam Skins (Templating Handler) `layout`, `view`, `partials`
- [ ] Static Websites Builder
- [x] Made for Front-end Development and Prototyping
- [x] Works on **Linux** and **OS X**
- [x] Open Source under `MIT` license

## Installing
Madam is currently available for **OS X** and **Linux distributions** only. You can compile Madam by yourself, or get a binary from /releases.

Setup Madam to your `PATH` and start do your thing!
```zsh
ln -s ~/path/to/your/madam /usr/local/bin
```

## Madame Commands
```zsh
Madam 0.1.0 💅 A local web server for Prototyping and Front-end Development
For updates, tips and tricks go to github.com/openpeep/madam

Usage:
   start [--quiet]                Start a new local server. Run in background with --quiet flag
   build                          Compile to a Static Website

Options:
  -h --help                       Show this screen.
  -v --version                    Show Madam version.
```

## Developing with Madam
Run `madam init` in your project directory and setup your `madam.yml` via command line wizard, or create the config file by hand, containing the following:

```yaml
name: "Awesome Madam"
path: "./example"                   # path to your HTML files
routes:                             # define your custom routes by key/value pointing to a HTML file
    index: "index.html"
    about: "about.html"

# Setup Static Assets to serve any
# kind of static files via Madam
assets:
    source: "./dist/assets/*"        # Path on disk for indexing the static assets
    public: "/assets"                # Public route for accessing the static assets
```

## Roadmap
finish the fukin job

### ❤ Contributions
If you like this project you can contribute to Madam by opening new issues, fixing bugs, contribute with code, ideas and you can even support us via [PayPal address pay@openpeep.ro](https://www.paypal.com/donate/?hosted_button_id=RJK3ZTDWPL55C) 🥰

### 👑 Discover Nim language
<strong>What's Nim?</strong> Nim is a statically typed compiled systems programming language. It combines successful concepts from mature languages like Python, Ada and Modula. [Find out more about Nim language](https://nim-lang.org/)

<strong>Why Nim?</strong> Performance, fast compilation and C-like freedom. We want to keep code clean, readable, concise, and close to our intention. Also a very good language to learn in 2022.

### 🎩 License
Madam is an Open Source Software released under `MIT` license. Developed by [OpenPeep](https://github.com/openpeep).<br>
Copyright &copy; 2022 OpenPeep & Contributors &mdash; All rights reserved.
