AtomPerl6EditorTools = require '../lib/atom-perl6-editor-tools'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "AtomPerl6EditorTools", ->
  [workspaceElement, activationPromise] = []

