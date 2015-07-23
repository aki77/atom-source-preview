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
* Babel: [source-preview-babel](https://atom.io/packages/source-preview-babel)
* React(JSX): [source-preview-react](https://atom.io/packages/source-preview-react)
* React(CJSX): [source-preview-react](https://atom.io/packages/source-preview-react)
* Jade: [source-preview-jade](https://atom.io/packages/source-preview-jade)

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
