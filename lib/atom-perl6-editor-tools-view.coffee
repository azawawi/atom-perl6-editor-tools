fs                    = require 'fs'
Buffer                = (require 'buffer').Buffer
{BufferedProcess, CompositeDisposable, Disposable} = require 'atom'
{$, $$$, ScrollView}  = require 'atom-space-pen-views'
path                  = require 'path'
os                    = require 'os'
tmp                   = require 'tmp'

module.exports =
class AtomPodPreviewView extends ScrollView
  atom.deserializers.add(this)

  editorSub           : null
  onDidChangeTitle    : -> new Disposable()
  onDidChangeModified : -> new Disposable()

  @deserialize: (state) ->
    new AtomPodPreviewView(state)

  @content: ->
    @div class: 'atom-perl6-editor-tools native-key-bindings', tabindex: -1

  constructor: ({@editorId, filePath}) ->
    super

    if @editorId?
      @resolveEditor(@editorId)
      @tmpPath = @getPath() # after resolveEditor
    else
      if atom.workspace?
        @subscribeToFilePath(filePath)
      else
        # @subscribe atom.packages.once 'activated', =>
        atom.packages.onDidActivatePackage =>
          @subscribeToFilePath(filePath)

  serialize: ->
    deserializer : 'AtomPodPreviewView'
    filePath     : @getPath()
    editorId     : @editorId

  destroy: ->
    # @unsubscribe()
    @editorSub.dispose() if @editorSub

  subscribeToFilePath: (filePath) ->
    @trigger 'title-changed'
    @handleEvents()
    @renderHTML()

  resolveEditor: (editorId) ->
    resolve = =>
      @editor = @editorForId(editorId)

      if @editor?
        @trigger 'title-changed' if @editor?
        @handleEvents()
      else
        # The editor this preview was created for has been closed so close
        # this preview since a preview cannot be rendered without an editor
        atom.workspace?.paneForItem(this)?.destroyItem(this)

    if atom.workspace?
      resolve()
    else
      # @subscribe atom.packages.once 'activated', =>
      atom.packages.onDidActivatePackage =>
        resolve()
        @renderHTML()

  editorForId: (editorId) ->
    for editor in atom.workspace.getTextEditors()
      return editor if editor.id?.toString() is editorId.toString()
    null

  handleEvents: =>

    changeHandler = =>
      @renderHTML()
      pane = atom.workspace.paneForURI(@getURI())
      if pane? and pane isnt atom.workspace.getActivePane()
        pane.activateItem(this)

    @editorSub = new CompositeDisposable

    if @editor?
      @editorSub.add @editor.onDidStopChanging changeHandler
      @editorSub.add @editor.onDidChangePath => @trigger 'title-changed'

  renderHTML: ->
    if @editor?
      @renderHtmlCode()

  # Renders the Perl 6 code to HTML via Pod::To::Html
  renderPod6Html: (onSuccess) ->
    self        = this

    tmp.file( (err, path, fd, cleanupCallback) ->
      throw err if err

      onP6TempFileSaved = (err) ->
        # throw an exception on file save failure
        throw err if err

        # Generate HTML from Perl 6 POD
        #TODO take command from config parameter
        command   = 'perl6'
        args      = ['--doc=HTML', path]
        stdout  = (output) ->
          onSuccess(output)
          return
        stderr  = (output) ->
          console.warn(output)
          return
        exit    = (code) ->
          unless code == 0
            atom.notifications.addWarning("Failed to create POD Preview content")
            return
          return
        # Run perl6 --doc=HTML [temp-file-name]
        process   = new BufferedProcess({command, args, stdout, stderr, exit})
        return

      # Write a snapshot of the Perl 6 editor in a temporary file
      buf = new Buffer(self.editor.getText())
      fs.write(fd, buf, 0, buf.length, onP6TempFileSaved)
    )
    return

  save: (onHtmlSaved) ->
    self = this

    onPod6HtmlReady = (html) ->
      tmp.file( (err, path, fd, cleanupCallback) ->
        throw err if err
        # Add base tag to allow relative links to work despite being loaded
        # as the src of an iframe
        css = self.makeCssStyles()

        html = html.replace('<link rel="stylesheet" href="//design.perl6.org/perl.css">', "<style>#{css}</style>")
        modifiedHtml = "<base href=\"" + self.getPath() + "\">" + html
        self.tmpPath = path

        # Write the modified generated HTML in a temporary file
        buf = new Buffer(modifiedHtml)
        fs.write(fd, buf, 0, buf.length, onHtmlSaved)

        return
      )
      return

    @renderPod6Html(onPod6HtmlReady)
    return

  renderHtmlCode: (text) ->
    if @editor.getPath()? then @save () =>
      iframe = document.createElement("iframe")

      # Allows for the use of relative resources (scripts, styles)
      iframe.setAttribute("sandbox", "allow-scripts allow-same-origin")
      iframe.src = @tmpPath
      @html $ iframe
      atom.commands.dispatch('atom-perl6-editor-tools', 'html-changed')

  getTitle: ->
    if @editor?
      "#{@editor.getTitle()} - POD Preview"
    else
      "POD Preview"

  getURI: ->
    "pod-preview://editor/#{@editorId}"

  getPath: ->
    if @editor?
      @editor.getPath()

  showError: (result) ->
    failureMessage = result?.message

    @html $$$ ->
      @h2 'POD Preview Failed'
      @h3 failureMessage if failureMessage?

  makeCssStyles: ->
    myStyle = ''
    for style in atom.styles.getStyleElements()
      continue if style.textContent.indexOf('atom-perl6-editor-tools') == -1
      myStyle = style.textContent
    results = []
    regex = /\.atom-perl6-editor-tools\siframe\.(\w+\s*\{\s*(.|\s)+?\})/g;
    while ((match = regex.exec(myStyle)))?
      results.push(match[1])
    css = results.join("\n")
    return css
