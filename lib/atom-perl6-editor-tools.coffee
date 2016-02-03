url                   = require 'url'
{CompositeDisposable} = require 'atom'

HtmlPreviewView       = require './atom-perl6-editor-tools-view'

module.exports =
  config:
    triggerOnSave:
      type        : 'boolean'
      description : 'Watch will trigger on save.'
      default     : false

  htmlPreviewView: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-perl6-editor-tools:toggle': => @toggle()

    atom.workspace.addOpener (uriToOpen) ->
      try
        {protocol, host, pathname} = url.parse(uriToOpen)
      catch error
        return

      return unless protocol is 'html-preview:'

      try
        pathname = decodeURI(pathname) if pathname
      catch error
        return

      if host is 'editor'
        new HtmlPreviewView(editorId: pathname.substring(1))
      else
        new HtmlPreviewView(filePath: pathname)

    '''
    #atom.workspace.observeTextEditors (editor) ->
    #  atom.notifications.addInfo("Filename :" + editor.getTitle() );

    #textEditor.onDidStopChanging () ->
    #  console.log "changed!"

    err = (err) ->
      throw err if err
      console.log("It's saved!");
    fs.writeFile 'Sample.pm6', editor.getText(), err

    #TODO write to temporary file
    #tmp.file _tempFileCreated -> (err, path, fd, cleanupCallback)
    #  throw err if err
    #  console.log "File: ", path
    #  console.log "Filedescriptor: ", fd;
    #  cleanupCallback();

    atom.workspace.open("p//editor/#{editor.id}", options).then (podPreviewEditor) ->
      #TODO File::Which perl6
      command = 'perl6'
      args    = ['--doc=HTML', 'Sample.pm6']
      stdout  = (output) ->
        console.log(output)
        atom.notifications.addSuccess(output)
        podPreviewEditor.setText output
      exit    = (code) ->
        console.log("perl6 --doc exited with #{code}")
        atom.notifications.addInfo("'#{command} #{args.join(" ")}' exited with #{code}")
      process = new BufferedProcess({command, args, stdout, exit})
    '''

  toggle: ->
    editor = atom.workspace.getActiveTextEditor()
    return unless editor?

    uri = "html-preview://editor/#{editor.id}"

    previewPane = atom.workspace.paneForURI(uri)
    if previewPane
      previewPane.destroyItem(previewPane.itemForURI(uri))
      return

    previousActivePane = atom.workspace.getActivePane()
    atom.workspace.open(uri, split: 'right', searchAllPanes: true).done (htmlPreviewView) ->
      if htmlPreviewView instanceof HtmlPreviewView
        htmlPreviewView.renderHTML()
        previousActivePane.activate()

  deactivate: ->
    @subscriptions.dispose()
