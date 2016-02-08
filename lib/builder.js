"use babel";

fs = require("fs")
path = require("path")

/**
 * This provides builder support for Perl 6 using linter
 * Please see https://atom.io/packages/build
 */
module.exports =
class Perl6BuildProvider {

  constructor(cwd) {
    this.cwd = cwd
    return
  }

  getNiceName() {
    return 'Perl 6 Builder'
  }

  isEligible() {
    return fs.existsSync(path.join(this.cwd, 't'))
  }

  settings() {
    return [{
      "name": "Run Perl 6 tests",
      "exec": "prove",
      "args": ['-v', '-e', 'perl6', "-Ilib"],
      "sh": false
    }]
  }

}