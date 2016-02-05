fs = require("fs")

# This provides linter support for Perl 6 using linter
# Please see https://atom.io/packages/linter
module.exports =
class Perl6BuildProvider

  cwd: null

  constructor: (cwd) ->
    console.log("cwd = " + cwd)
    @cwd = cwd
    return

  getNiceName: ->
    return 'Perl 6 Builder'

  isEligible: ->
    # REQUIRED: Perform operations to determine if this build provider can
    # build the project in `cwd` (which was specified in `constructor`).
    return true #fs.existsSync(path.join(@cwd, 't'))

  settings: ->
    # REQUIRED: Return an array of objects which each define a build description.
    return [
      "name": "panda test"
      "exec": "panda test ."
      "sh": false
    ]
