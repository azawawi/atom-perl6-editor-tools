fs                    = require 'fs'
{BufferedProcess, CompositeDisposable, Disposable} = require 'atom'
{$, $$$, ScrollView}  = require 'atom-space-pen-views'
path                  = require 'path'
os                    = require 'os'

module.exports =
class AtomHtmlPreviewView extends ScrollView
  atom.deserializers.add(this)

  editorSub           : null
  onDidChangeTitle    : -> new Disposable()
  onDidChangeModified : -> new Disposable()

  @deserialize: (state) ->
    new AtomHtmlPreviewView(state)

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
    deserializer : 'AtomHtmlPreviewView'
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
    @showLoading()
    if @editor?
      @renderHTMLCode()

  # Renders the Perl 6 code to HTML via Pod::To::Html
  renderPOD62HTML: (onSuccess) ->
    tmpFileName = "Temp.pm6";

    onSave = (err) ->
      # throw an exception on file save failure
      throw err if err

      atom.notifications.addSuccess("It's saved!")

      #TODO take command from config parameter
      command   = 'perl6'
      args      = ['--doc=HTML', tmpFileName]

      stdout  = (output) ->
        #atom.notifications.addInfo(output)
        onSuccess(output)

      exit    = (code) ->
        atom.notifications.addInfo("'#{command} #{args.join(" ")}' exited with #{code}")

      # Run perl6 --doc=HTML #{tmp_editor_snapshot}
      process   = new BufferedProcess({command, args, stdout, exit})

    fs.writeFile tmpFileName, @editor.getText(), onSave

  save: (callback) ->
    self = this

    onSaveTempHTMLFile = (html) ->
      # Temp file path
      outPath = path.resolve( path.join(os.tmpdir(), self.editor.getTitle()) )

      atom.notifications.addInfo(html)
      # Add base tag; allow relative links to work despite being loaded
      # as the src of an iframe
      out = "<base href=\"" + self.getPath() + "\">" + html
      self.tmpPath = outPath

      # And we're back
      #callback()

      # Save it!
      fs.writeFile(outPath, out, onSaveTempHTMLFile)

    @renderPOD62HTML(onSaveTempHTMLFile)

  renderHTMLCode: (text) ->
    if @editor.getPath()? then @save () =>
      iframe = document.createElement("iframe")
      # Allows for the use of relative resources (scripts, styles)
      iframe.setAttribute("sandbox", "allow-scripts allow-same-origin")
      iframe.src = @tmpPath
      @html $ iframe
      atom.commands.dispatch 'atom-perl6-editor-tools', 'html-changed'

  getTitle: ->
    if @editor?
      "#{@editor.getTitle()} Preview"
    else
      "HTML Preview"

  getURI: ->
    "pod-preview://editor/#{@editorId}"

  getPath: ->
    if @editor?
      @editor.getPath()

  showError: (result) ->
    failureMessage = result?.message

    @html $$$ ->
      @h2 'Previewing HTML Failed'
      @h3 failureMessage if failureMessage?

  showLoading: ->
    @html $$$ ->
      @div class: 'atom-html-spinner', 'Loading HTML Preview\u2026'
