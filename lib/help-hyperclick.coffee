
fs   = require 'fs'
path = require 'path'

# This provides hyperclick support for Perl 6 using hyperclick
# Please see https://atom.io/packages/hyperclick
module.exports =
class Perl6HyperclickProvider

  keywords = []

  constructor: () ->
    self = this

    # Find path of data/perl6-help.index.json
    myPackageFolder = atom.packages.getLoadedPackage("atom-perl6-editor-tools").path
    filename = path.join(myPackageFolder, "data", "perl6-help-index.json")

    # Read data/perl6-help.index.json async and extract its keywords
    fs.readFile(filename, 'utf8', (err, data) ->
      # We failed
      throw err if err

      # Parse JSON
      recs = JSON.parse(data)

      # And keywords hash
      keywords = {}
      for rec in recs
        key = rec["value"]
        keywords[key] =
          category: rec["category"]
          url: rec["url"]

      # Keep keywords hash for later usage
      self.keywords = keywords
    )

  providerName:  'perl6-hyperclick'

  # This is called by hyperclick plugin when the user holds Ctrl and then clicks
  # the underlined word
  getSuggestionForWord: (editor, word, range) ->
    # Make sure the editor are valid Perl 6 editors
    return unless editor?
    grammar = editor.getGrammar()
    return unless grammar? && grammar.scopeName? && grammar.scopeName.startsWith("source.perl6")
    return unless @keywords?

    o = @keywords[word]
    helpText = null
    if o?
      url = "http://doc.perl6.org#{o.url}"
      helpText = """
        <strong>Category:</strong>&nbsp;&nbsp;#{o.category}
        <br><strong>URL:</strong>&nbsp;&nbsp;<a href=\"#{url}\">#{url}</a>
      """

    # Return help callback and ranges to suggestion provider (hyperclick)
    return {
      range: range,
      callback: () ->
        options =
          dismissable: true
        if helpText?
          atom.notifications.addInfo(helpText, options)
        else
          atom.notifications.addWarning("Help not found for #{word}")
        return
    }
