AtomPerl6EditorToolsView = require './atom-perl6-editor-tools-view'
{CompositeDisposable}    = require 'atom'
{BufferedProcess}        = require 'atom'

module.exports = AtomPerl6EditorTools =
  atomPerl6EditorToolsView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomPerl6EditorToolsView = new AtomPerl6EditorToolsView(state.atomPerl6EditorToolsViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomPerl6EditorToolsView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-perl6-editor-tools:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomPerl6EditorToolsView.destroy()

  serialize: ->
    atomPerl6EditorToolsViewState: @atomPerl6EditorToolsView.serialize()

  toggle: ->
    #console.log 'AtomPerl6EditorTools was toggled!'
    #atom.notifications.addInfo("Perl 6 Editor tools was toggled!");
    #textEditor = atom.workspace.getActiveTextEditor()
    #console.log textEditor

    #atom.workspace.observeTextEditors (editor) ->
    #  atom.notifications.addInfo("Filename :" + editor.getTitle() );
      
    #textEditor.onDidStopChanging () ->
    #  console.log "changed!"

    #TODO File::Which perl6
    command = 'perl6'
    args    = ['--doc=HTML', '-']
    stdout  = (output) ->
      console.log(output)
      atom.notifications.addSuccess(output)

    exit    = (code) ->
      console.log("perl6 --doc exited with #{code}")
      atom.notifications.addInfo("perl6 --doc exited with #{code}")
    data = '=begin pod\nHello\=end pod'
    process = new BufferedProcess({command, args, stdout, exit, data})
    #if @modalPanel.isVisible()
    #  @modalPanel.hide()
    #else
    #  @modalPanel.show()
