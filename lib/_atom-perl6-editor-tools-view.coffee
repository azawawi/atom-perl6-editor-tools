{ScrollView} = require 'atom-space-pen-views'

module.exports =
class AtomPerl6EditorToolsView extends ScrollView
  @content: ->
    @div()

  initialize: ->
    super
    @text('super long content that will scroll')
