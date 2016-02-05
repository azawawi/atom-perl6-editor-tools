fs = require("fs")
path = require("path")

# This provides linter support for Perl 6 using linter
# Please see https://atom.io/packages/linter
module.exports =
class Perl6BuildProvider

  cwd: null

  constructor: (cwd) ->
    @cwd = cwd
    return

  getNiceName: ->
    return 'Perl 6 Builder'

  isEligible: ->
    # REQUIRED: Perform operations to determine if this build provider can
    # build the project in `cwd` (which was specified in `constructor`).
    return fs.existsSync(path.join(@cwd, 't'))

  settings: ->
    # REQUIRED: Return an array of objects which each define a build description.
    return [
      "name": "Run Perl 6 tests"
      "exec": "prove"
      "args": ['-v', '-e', 'perl6', "-Ilib"]
      "sh": false
    ]
