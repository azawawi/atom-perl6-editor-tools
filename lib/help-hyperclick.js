"use babel";

fs    = require('fs')
path  = require('path')
rp    = null;

/**
 * This provides hyperclick support for Perl 6 using hyperclick
 * Please see https://atom.io/packages/hyperclick
 */
module.exports =
class Perl6HyperclickProvider {

  constructor()  {
    this.keywords = {}

    // Find path of data/perl6-help.index.json
    myPackageFolder = atom.packages.getLoadedPackage("atom-perl6-editor-tools").path
    filename = path.join(myPackageFolder, "data", "perl6-help-index.json")

    // Read data/perl6-help.index.json async and extract its keywords
    fs.readFile(filename, 'utf8', (err, data) => {
      // Did we fail?
      if (err) {
        throw err
      }

      // Keep keywords hash for later usage
      this.keywords = JSON.parse(data)
    }
    )
  }

  providerName = 'perl6-hyperclick'

  // This is called by hyperclick plugin when the user holds Ctrl and then clicks
  // the underlined word
  getSuggestionForWord(editor, word, range) {
    // Editor must be defined
    if (!editor) {
      return
    }

    // Editor must be a Perl 6 editor
    grammar = editor.getGrammar()
    if( !( grammar && grammar.scopeName && grammar.scopeName.startsWith("source.perl6") ) ) {
      return
    }

    // Keywords should be defined
    if( !this.keywords ) {
      return
    }

    helpRecs = this.keywords[word]

    // Return help callback and ranges to suggestion provider (hyperclick)
    return {
      range: range,
      callback: () => {
        if (!helpRecs || helpRecs && helpRecs.length == 0) {
          atom.notifications.addWarning(`Help not found for ${word}`)
          return
        }

        // TODO display more than one help result?
        o = helpRecs[0]

        url = `https://doc.perl6.org${o.url}.html`
        onResolve = (content ) => {
          regex = /<div id="content" class="pretty-box yellow">((.|\s)+?)<\/div>\s*<footer class="pretty-box yellow">/
          match = regex.exec(content)
          if(match) {
            helpText = `<strong>Category:<\/strong>&nbsp;&nbsp;${o.category}
<br><strong>URL:<\/strong>&nbsp;&nbsp;<a href=\"${url}\">${url}</a>
${match[1]}`
            atom.notifications.addInfo(helpText, { dismissable: true })
          } else {
            atom.notifications.addWarning(`Failed to match ${url}`)
          }
          return
        }
        onReject  = (code) => {
          atom.notifications.addWarning(`Failed to fetch ${url}`)
          return
        }

        // Return a promise
        if (rp == null) {
          // Lazily load since it is somehow slow on startup
          rp = require('request-promise')
        }
        return rp(url).then(onResolve, onReject)
      }
    }
  }

}
