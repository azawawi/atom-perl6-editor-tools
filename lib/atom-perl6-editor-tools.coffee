url                   = require 'url'
{BufferedProcess, CompositeDisposable} = require 'atom'

PodPreviewView        = require './atom-perl6-editor-tools-view'

module.exports =
  #config:
  #  "perl6-exec-path":
  #    type        : 'string'
  #    description : 'Path to perl6 executable'
  #    default     : ""

  htmlPreviewView: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-perl6-editor-tools:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-perl6-editor-tools:run-tests': => @run_tests()

    atom.workspace.addOpener (uriToOpen) ->
      try
        {protocol, host, pathname} = url.parse(uriToOpen)
      catch error
        return

      return unless protocol is 'pod-preview:'

      try
        pathname = decodeURI(pathname) if pathname
      catch error
        return

      if host is 'editor'
        new PodPreviewView(editorId: pathname.substring(1))
      else
        new PodPreviewView(filePath: pathname)

  run_tests: ->
    #TODO take command from config parameter
    command   = 'prove'
    args      = ['-v', '-e', 'perl6']

    #TODO more robust detection of cwd
    options =
      cwd: cwd = atom.project.getDirectories()[0].path
      env: process.env

    stdout  = (text) ->
      atom.notifications.addSuccess(text)
      return

    stderr  = (text) ->
      atom.notifications.addError(text)
      return

    exit    = (code) ->
      atom.notifications.addInfo("'#{command} #{args.join(" ")}' exited with #{code}")
      return

    # Run `prove -v -e "perl6 -Ilib"`
    atom.notifications.addInfo("Starting running #{command} #{args.join(" ")}'...")
    new BufferedProcess({command, args, options, stdout, stderr, exit})

  toggle: ->
    editor = atom.workspace.getActiveTextEditor()
    return unless editor?

    uri = "pod-preview://editor/#{editor.id}"

    previewPane = atom.workspace.paneForURI(uri)
    if previewPane
      previewPane.destroyItem(previewPane.itemForURI(uri))
      return

    previousActivePane = atom.workspace.getActivePane()
    atom.workspace.open(uri, split: 'right', searchAllPanes: true).done (htmlPreviewView) ->
      if htmlPreviewView instanceof PodPreviewView
        htmlPreviewView.renderHTML()
        previousActivePane.activate()

  deactivate: ->
    @subscriptions.dispose()
