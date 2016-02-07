
fs   = require 'fs'
path = require 'path'
Q    = require('q');
HTTP = require('http')
URL  = require('url')

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

    # Return help callback and ranges to suggestion provider (hyperclick)
    self = this
    options =
      dismissable: true
    return {
      range: range,
      callback: ->
        unless o?
          atom.notifications.addWarning("Help not found for #{word}")
          return

        url = "http://doc.perl6.org#{o.url}"
        onResolve = (content ) ->
          regex = /<div id="content-wrapper">\s*<div id="content" class="pretty-box yellow">((.|\s)+?)<\/div>\s*<\/div>\s*<div id="footer-wrapper">/
          match = regex.exec(content)
          if match?
            helpText = """
              <strong>Category:</strong>&nbsp;&nbsp;#{o.category}
              <br><strong>URL:</strong>&nbsp;&nbsp;<a href=\"#{url}\">#{url}</a>
              #{match[1]}
            """
            console.log(atom.notifications.addInfo(match[1], options))
          else
            atom.notifications.addWarning("Failed to match #{url}")
          return
        onReject  = (code) ->
          atom.notifications.addWarning("Failed to fetch #{url}")
          return

        # Return a promise
        return self.fetchURL(url).then(onResolve, onReject)
    }

  fetchURL : ( url ) ->
    urlObj = URL.parse(url)
    deferred = Q.defer()
    onResponse = (response) ->
      deferred.reject(response.statusCode) unless (response.statusCode == 200)
      content = ''
      response.on('data', (chunk) -> content += chunk )
      response.on('end',          -> deferred.resolve(content) )
      response.resume()
      return

    HTTP.get(
      hostname: urlObj.host,
      port: 80,
      path: urlObj.path,
      agent: false  # create a new agent just for this one request
    , onResponse)

    # Return a deferred promise :)
    return deferred.promise
