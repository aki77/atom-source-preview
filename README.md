# source-preview package

Source Preview for Atom.
[![Build Status](https://travis-ci.org/aki77/atom-source-preview.svg)](https://travis-ci.org/aki77/atom-source-preview)

[![Gyazo](http://i.gyazo.com/e391eb2802466ffa86111577052d02b7.gif)](http://gyazo.com/e391eb2802466ffa86111577052d02b7)

## Features

* Live updating of preview
* Shows error messages
* Synchronize cursor

## Supported Languages

* CoffeeScript
* Babel: [language\-babel](https://atom.io/packages/language-babel)
* Pug(Jade): [source\-preview\-pug](https://atom.io/packages/source-preview-pug)

## Commands

* `source-preview:toggle`

## Settings

* `enableBuiltinProvider` (default: true)

## Keymap

No keymap by default.

edit `~/.atom/keymap.cson`

```coffeescript
'atom-text-editor[data-grammar~="source"]':
  'ctrl-M': 'source-preview:toggle'
```
