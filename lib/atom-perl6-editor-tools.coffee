url                   = require 'url'
{BufferedProcess, CompositeDisposable} = require 'atom'

PodPreviewView        = require './atom-perl6-editor-tools-view'
Perl6Linter           = require './atom-perl6-editor-tools-linter'
Perl6Builder          = require './atom-perl6-editor-tools-builder'
Perl6Hyperclick       = require './atom-perl6-editor-tools-hyperclick'

module.exports =
  #config:
  #  "perl6-exec-path":
  #    type        : 'string'
  #    description : 'Path to perl6 executable'
  #    default     : ""

  podPreviewView: null

  activate: (state) ->
    # Install package-deps section in package.json without user intervention
    require('atom-package-deps').install()
      .then ->
        console.log("All deps are installed, it's good to go")

    # Determine whether language-perl is enabled or not
    disabledPackages = atom.config.get("core.disabledPackages")
    enabled = true
    for pkg in disabledPackages
      enabled = false if (pkg == "language-perl")

    # Warn when language-perl is enabled!
    atom.notifications.addWarning("Please disable language-perl for a better Perl 6 syntax highlighted code") if enabled

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-perl6-editor-tools:pod-preview': => @podPreview()

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

  podPreview: ->
    # Open POD Preview on a valid editor and warn if otherwise
    editor = atom.workspace.getActiveTextEditor()
    unless editor?
      atom.notifications.addWarning("No editor found. Aborting...")
      return

    # Open POD Preview only on a valid Perl6 editor and warn if otherwise
    grammar = editor.getGrammar()
    unless grammar? && grammar.scopeName? && grammar.scopeName.startsWith("source.perl6")
      atom.notifications.addWarning("No Perl 6 editor found. Aborting...")
      return

    # Open POD Preview only if Pod::To::HTML is installed and warn if otherwise
    openPodPreview = @openPodPreview
    @checkForPodToHtml(-> openPodPreview(editor) )

    return

  openPodPreview: (editor) ->
    # Double check that the editor is valid
    return unless editor?

    uri = "pod-preview://editor/#{editor.id}"

    previewPane = atom.workspace.paneForURI(uri)
    if previewPane
      previewPane.destroyItem(previewPane.itemForURI(uri))
      return

    previousActivePane = atom.workspace.getActivePane()
    atom.workspace.open(uri, split: 'right', searchAllPanes: true).done (podPreviewView) ->
      if podPreviewView instanceof PodPreviewView
        podPreviewView.renderHTML()
        previousActivePane.activate()

  deactivate: ->
    @subscriptions.dispose()

  checkForPodToHtml: (onSuccess) ->
    #TODO take command from config parameter
    command   = 'perl6'
    args      = ["-e use Pod::To::HTML; 0"]

    exit    = (code) ->
      if code == 0
        onSuccess()
      else
        atom.notifications.addWarning("Pod::To::HTML is not installed. Aborting...")
      return

    # Run perl6 -e 'use Pod::To::HTML'
    process   = new BufferedProcess({command, args, exit})

  # Perl 6 linter
  provideLinter: ->
    return new Perl6Linter

  # Perl 6 builder
  provideBuilder: ->
    return Perl6Builder

  # Perl 6 context-sensitive help
  provideHyperclick: ->
    return new Perl6Hyperclick
