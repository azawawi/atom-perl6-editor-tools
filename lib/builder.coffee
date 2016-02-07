fs = require("fs")
path = require("path")

# This provides builder support for Perl 6 using linter
# Please see https://atom.io/packages/build
module.exports =
class Perl6BuildProvider

  cwd: null

  constructor: (cwd) ->
    @cwd = cwd
    return

  getNiceName: ->
    return 'Perl 6 Builder'

  isEligible: ->
    return fs.existsSync(path.join(@cwd, 't'))

  settings: ->
    return [
      "name": "Run Perl 6 tests"
      "exec": "prove"
      "args": ['-v', '-e', 'perl6', "-Ilib"]
      "sh": false
    ]
