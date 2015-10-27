# Haskell on mobile devices

[![Build Status](http://circleci-badges-max.herokuapp.com/img/abarbu/haskell-mobile/master?token=ed510657bb935eb3f0b2450cb853d6759e2e6b6b)](https://circleci.com/gh/abarbu/haskell-mobile/tree/master)

An environment to build apps for mobile devices, Android & iOS, with
bindings to all of the native SDKs including UIs all in Haskell. Note
that while this is functional, as in one can in principle build any
app with full access to all of the Android/iOS APIs, it's still in its
early days. Right now only one example project is provided and it
doesn't integrate with the native UI designers (e.g., Android
Studio). This integration is the last major technical missing piece.

The example project provided is a straightforward port of the
Nativescript hello world template. A button and some labels. Note that
this isn't good Haskell code! And isn't meant to be such. It sticks by
the conventions and layout of the original in order to make it easier
to understand how it was ported. Run `tns create hello` in a directory
other than the repo to get the original hello world example.

We use GHCJS to compile down to Javascript and
[Nativescript](https://www.nativescript.org/) to bind to the
Android/iOS APIs. Nativescript did much of the heavy lifting of
providing bindings for all of the Android and iOS APIs in Javascript
as well as figuring out how to bundle V8 on those platforms.

The basics presented here can be reused for iOS. Indeed as long as an
app doesn't use platform-specific APIs it should be portable. But I
don't have any iOS devices so this is all untested on that platform.

Docker containers are provided with all the tools required. Some
images are quite large, like the GHCJS one, and may take a while to
download.

## Running

N.B: As mentioned earlier this is still in its early stages. Rough
corners and bleeding edges await.

You'll need two containers, one with Stackage and GHCJS and the other
with Nativescript.

```bash
docker pull abarbu/nativescript
docker pull abarbu/stack-ghcjs-nativescript:lts-3.0
```

We'll be the running from inside the containers so lets set up some aliases

```bash
alias tns='docker run -it --rm --privileged --net=host -v /dev/bus/usb:/dev/bus/usb -v $PWD:/src abarbu/nativescript tns'
alias logcat='docker run -it --rm --privileged --net=host -v /dev/bus/usb:/dev/bus/usb -v $PWD:/src abarbu/nativescript pidcat'
alias ghcjs='docker run -it --rm -v $PWD:/src abarbu/stack-ghcjs-nativescript:lts-3.0 ghcjs'
```

Lets try the simple Hello World app that Nativescript ships with and
we've ported to Haskell.

```bash
cd hello
tns platform add android
cd app
ghcjs App.hs
tns run android
```

Your android phone has to be hooked up for this to work and you can't
have a running adb server on the host (there might be version skew
between the container and the host resulting in a real mess). If in
doubt just run `adb kill-server`. Right now the emulator segfaults on
startup on my machine but instructions for how to install it are in
the android docker file and you can just run `tns run android --emulate`.
Note that as usual you'll have to enable USB debugging and accept it
permanently for your machine.

This should start up the app on your phone. For development it's much
easier if we automate things a bit. I run each of the 3 commands in
separate terminals.

```bash
cd hello; tns livesync android --watch
logcat org.nativescript.hello
cd hello/app; nodemon --exec "ghcjs" *.hs
```

The code of the app is in App.hs. You can have as many modules as you
want and they will be linked in as usual. In NativeScript app.js
contains the main entry point to the activity. The rest of the code is
distributed in views which each have css, js, and xml files. For the
Haskell case all of the code lives in the app.js file and the js files
for the views just refer to it. Check out the example app to see how
this works but it's totally trivial and mechanical.

## Rebuilding the docker containers

In case you want to build your own containers you can get a copy of
the docker files from
[https://github.com/abarbu/haskell-mobile](https://github.com/abarbu/haskell-mobile)
and rebuild with:

```bash
docker build -t abarbu/java:8 java
docker build -t abarbu/android:22 android
docker build -t abarbu/node.js:0.12 node.js
docker build -t abarbu/nativescript nativescript
docker build -t abarbu/stack-ghcjs-nativescript:lts-3.0 stack-ghcjs-nativescript
```

This package is distributed under the MIT License

Copyright (c) 2015 Andrei Barbu <andrei@0xab.com>
