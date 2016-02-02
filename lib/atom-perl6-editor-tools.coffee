AtomPerl6EditorToolsView = require './atom-perl6-editor-tools-view'
{CompositeDisposable} = require 'atom'

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
    console.log 'AtomPerl6EditorTools was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
