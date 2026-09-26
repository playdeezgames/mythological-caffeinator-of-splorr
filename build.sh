#!/usr/bin/env bash

odin build src -target:js_wasm32 -out:build/metaphor.wasm
cp -f src/index.html build/index.html
cp -f src/odin.js build/odin.js
cp -f src/app.css build/app.css

