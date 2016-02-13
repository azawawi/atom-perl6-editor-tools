"use babel"

helpers = require('atom-linter')
path    = require('path')

// This provides linter support for Perl 6 using linter
// Please see https://atom.io/packages/linter
module.exports =
class Perl6Linter {
  
  constructor() {
    this.name          = 'Perl 6 Syntax Check'
    this.grammarScopes = ['source.perl6', 'source.perl6fe']
    this.scope         = 'file'
    this.lintOnFly     = true
  }

  lint(textEditor) {
    command = "perl6"
    args = ["-Ilib", '-c', "-"]

    // Find project directory for the text editor provided
    projectDir = atom.project.getDirectories().find(
      (dir) => {
        return dir.contains(textEditor.getPath() )
      }
    )
    projectDir = projectDir.path ? projectDir.path : null;

    options = {
      cwd: projectDir,
      stream : "",
      stdin  : textEditor.getText()
    }
    return helpers.exec(command, args, options).then( (output) => {
      console.log(output)

      // return nothing if no errors are found
      if (output.stdout.startsWith("Syntax OK") && output.stderr == "") {
        return []
      }

      // Try to find the error message and line number
      regex = /(.+\s+at.+?(\d+)\s+.+)/
      stderr = output.stderr
      match = regex.exec(stderr)
      if (match) {
        // Success
        // Remove the ansi escape sequence noise from the message
        message = match[1].replace(/\\x1b\[\d+(;\d+)?m/g, "")
        line    = match[2] - 1
      } else {
        // We failed, at least show the message without line number information
        message = stderr.replace("===SORRY!===", "")
        line    = 0
      }

      // The error message is for the whole line
      colEnd = textEditor.getBuffer().lineLengthForRow(line)

      // Return the message to atom lint plugin
      return [{
        type: 'Error',
        text: message,
        range:[[line, 0], [line, colEnd]],
        filePath: textEditor.getPath()
      }]
    })
  }
}