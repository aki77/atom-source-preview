# coffee-preview package

CoffeeScript Preview for Atom.
[![Build Status](https://travis-ci.org/aki77/atom-coffee-preview.svg)](https://travis-ci.org/aki77/atom-coffee-preview)

[![Gyazo](http://i.gyazo.com/01dc7a053c5a62cc3caa352a9ab35ee4.gif)](http://gyazo.com/01dc7a053c5a62cc3caa352a9ab35ee4)

## Features

* Live updating of preview
* Shows error messages
* Synchronize cursor

## Commands

* `coffee-preview:toggle`

## Keymap

No keymap by default.

edit `~/.atom/keymap.cson`

```coffeescript
'atom-text-editor[data-grammar~="coffee"]':
  'ctrl-M': 'coffee-preview:toggle'
```
