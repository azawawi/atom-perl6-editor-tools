AtomPerl6EditorToolsView = require './atom-perl6-editor-tools-view'
{CompositeDisposable}    = require 'atom'
{BufferedProcess}        = require 'atom'
fs                       = require('fs');
url                      = require('url');

module.exports = AtomPerl6EditorTools =
  #atomPerl6EditorToolsView: null
  #modalPanel: null
  subscriptions: null

  activate: (state) ->
    #@atomPerl6EditorToolsView = new AtomPerl6EditorToolsView(state.atomPerl6EditorToolsViewState)
    #@modalPanel = atom.workspace.addTopPanel(item: @atomPerl6EditorToolsView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-perl6-editor-tools:toggle': => @toggle()

  deactivate: ->
    #@modalPanel.destroy()
    @subscriptions.dispose()
    #@atomPerl6EditorToolsView.destroy()

  serialize: ->
    #atomPerl6EditorToolsViewState: @atomPerl6EditorToolsView.serialize()

  toggle: ->
    editor = atom.workspace.getActiveTextEditor()
    
    #atom.workspace.observeTextEditors (editor) ->
    #  atom.notifications.addInfo("Filename :" + editor.getTitle() );

    #textEditor.onDidStopChanging () ->
    #  console.log "changed!"
      
    atom.workspace.addOpener (uriToOpen) ->
      try
        {protocol, host, pathname} = url.parse(uriToOpen)
      catch error
        return

      return unless protocol is 'perl6-pod-preview:'

      alert(pathname)
      
      try
        pathname = decodeURI(pathname) if pathname
      catch error
        return

      if host is 'editor'
        new AtomPerl6EditorToolsView(editorId: pathname.substring(1))
      else
        alert "Not an editor?"

    options =
      split: 'right'
      
    err = (err) ->
      throw err if err 
      console.log("It's saved!");
    fs.writeFile 'Sample.pm6', editor.getText(), err

    atom.workspace.open("perl6-pod-preview://editor/#{editor.id}", options).then (podPreviewEditor) ->
      #TODO File::Which perl6
      command = 'perl6'
      args    = ['--doc=HTML', 'Sample.pm6']
      stdout  = (output) ->
        console.log(output)
        atom.notifications.addSuccess(output)
        podPreviewEditor.setText output
        alert("Done!")
      exit    = (code) ->
        console.log("perl6 --doc exited with #{code}")
        atom.notifications.addInfo("'#{command} #{args.join(" ")}' exited with #{code}")
      process = new BufferedProcess({command, args, stdout, exit})


    #if @modalPanel.isVisible()
    #  @modalPanel.hide()
    #else
    #  @modalPanel.show()
