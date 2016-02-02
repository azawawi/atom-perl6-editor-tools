module.exports =
class AtomPerl6EditorToolsView
  constructor: (serializedState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('atom-perl6-editor-tools')

    # Create message element
    message = document.createElement('div')
    message.textContent = "The AtomPerl6EditorTools package is Alive! It's ALIVE!"
    message.classList.add('message')
    @element.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
