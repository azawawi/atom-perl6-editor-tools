
fs   = require 'fs'
http = require 'http'

# This provides hyperclick support for Perl 6 using hyperclick
# Please see https://atom.io/packages/hyperclick
module.exports =
class Perl6HyperclickProvider

  keywords = []

  constructor: () ->
    self = this
    #TODO no hardcoding
    fs.readFile('/home/azawawi/atom-perl6-editor-tools/lib/index.json', 'utf8', (err, data) ->
      throw err if err
      recs = JSON.parse(data)
      keywords = {}
      for rec in recs
        key = rec["value"]
        keywords[key] =
          category: rec["category"]
          url: rec["url"]
      self.keywords = keywords
      atom.notifications.addInfo("Done reading index.json!")
    )

  providerName:  'perl6-hyperclick'

  getSuggestionForWord: (editor, word, range) ->
    # Make sure the editor are valid Perl 6 editors
    return unless editor?
    grammar = editor.getGrammar()
    return unless grammar? && grammar.scopeName? && grammar.scopeName.startsWith("source.perl6")

    o = @keywords[word]
    helpText = "Help not found for #{word}"
    if o?
      url = "http://doc.perl6.org#{o.url}"
      helpText = """
        <strong>Category:</strong>&nbsp;&nbsp;#{o.category}
        <br><strong>URL:</strong>&nbsp;&nbsp;<a href=\"#{url}\">#{url}</a>
      """

    return {
      range: range,
      callback: () ->
        options =
          dismissable: true
        atom.notifications.addInfo(helpText, options)
        return
    }
