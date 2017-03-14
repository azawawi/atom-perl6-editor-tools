"use babel";

let {BufferedProcess, CompositeDisposable} = require('atom')
let URL                 = require('url')
PodPreviewView          = require('./pod-preview')
Perl6LinterProvider     = require('./syntax-check-linter')
Perl6BuildProvider      = require('./builder')
Perl6HyperclickProvider = require('./help-hyperclick')
Perl6FileIconsProvider  = require('./file-icons')

module.exports = {

  // Plugin settings
  "config": {
      "helpHyperclickEnabled": {
        "title"   : "Toggle context-sensitive help hyperclick support (Atom restart needed)",
        "type"    : "boolean",
        "default" : true
      },
      "syntaxCheckLinterEnabled": {
        "title"   : "Toggle syntax check linter (Atom restart needed)",
        "type"    : "boolean",
        "default" : true
      },
      "fileIconsEnabled": {
        "title"   : "Toggle file icons in the tree view (Atom restart needed)",
        "type"    : "boolean",
        "default" : true
      }
  },

  // This is called on plugin activation by the Atom environment
  activate(state) {
    // Install package-deps section in package.json without user intervention
    require('atom-package-deps')
      .install()
      .then( () => {
        // All dependencies are now installed, let's roll
        this.activateAfterDepsCheck()
      })
  },

  // This is called once the dependencies are properly installed
  activateAfterDepsCheck() {

    // Disable language-perl if it is enabled!
    if (! atom.packages.isPackageDisabled("language-perl")) {
      atom.packages.disablePackage("language-perl")
      atom.notifications.addInfo("language-perl has been disabled for a more Perl 6 fun editing experience")
    }

    // Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    this.subscriptions = new CompositeDisposable

    // Register command that toggles this view
    this.subscriptions.add(
      atom.commands.add('atom-workspace', { 'main:pod-preview': () => { return module.exports.podPreview() } } ),
      atom.commands.add('atom-workspace', { 'main:new-p6-script': () => { return module.exports.newP6Script() } } ),
      atom.commands.add('atom-workspace', { 'main:new-p6-project': () => { return module.exports.newP6Project() } } )
    )

    atom.workspace.addOpener( (uriToOpen) => {
      let {protocol, host, pathname} = URL.parse(uriToOpen)

      if(protocol != 'pod-preview:') {
        return
      }

      try {
        if (pathname) {
          pathname = decodeURI(pathname) 
        }
      } catch(error) {
        console.error(error)
        return
      }

      if(host == 'editor') {
        return new PodPreviewView( { editorId: pathname.substring(1) } )
      } else {
        return new PodPreviewView( { filePath: pathname } )
      }
    })
  },

  podPreview() {
    // Open POD Preview on a valid editor and warn if otherwise
    editor = atom.workspace.getActiveTextEditor()
    if (!editor) {
      atom.notifications.addWarning("No editor found. Aborting...")
      return
    }

    // Open POD Preview only on a valid Perl6 editor and warn if otherwise
    grammar = editor.getGrammar()
    if (!  (grammar && grammar.scopeName && grammar.scopeName.startsWith("source.perl6")) ) {
      atom.notifications.addWarning("No Perl 6 editor found. Aborting...")
      return
    }

    // Open POD Preview only if Pod::To::HTML is installed and warn if otherwise
    module.exports.checkForPodToHtml( () => { module.exports.openPodPreview(editor) } )

    return
  },

  openPodPreview(editor) {
    // Double check that the editor is valid
    if(!editor) {
      return
    }

    uri = `pod-preview://editor/${editor.id}`

    previewPane = atom.workspace.paneForURI(uri)
    if(previewPane) {
      previewPane.destroyItem(previewPane.itemForURI(uri))
      return
    }

    previousActivePane = atom.workspace.getActivePane()
    atom.workspace.open(uri, { split: 'right', searchAllPanes: true} ).done( (podPreviewView) => {
      if (podPreviewView instanceof PodPreviewView) {
        podPreviewView.renderHTML()
        previousActivePane.activate()
      }
    });
  },

  deactivate: () => {
    this.subscriptions.dispose()
  },

  checkForPodToHtml(onSuccess) {
    // TODO take command from config parameter
    command   = 'perl6'
    args      = ["-e use Pod::To::HTML; 0"]

    exit    = (code) => {
      if (code == 0) {
        onSuccess()
      } else {
        atom.notifications.addWarning(
          `Pod::To::HTML is not installed.
          <br><br>Please type the following in your command line:<br>
          <pre>panda update\npanda install Pod::To::HTML</pre>`,
          { dismissable: true }
        )
      }
      return
    }

    // Run perl6 -e 'use Pod::To::HTML'
    process   = new BufferedProcess({command, args, exit})
  },

  // Perl 6 linter
  provideLinter() {
    if (atom.config.get("atom-perl6-editor-tools.syntaxCheckLinterEnabled")) {
      return new Perl6LinterProvider
    }

    return
  },

  // Perl 6 builder
  provideBuilder() {
    return Perl6BuildProvider
  },

  // Perl 6 context-sensitive help
  provideHyperclick() {
    if (atom.config.get("atom-perl6-editor-tools.helpHyperclickEnabled")) {
      return new Perl6HyperclickProvider
    }

    return
  },

  // Perl 6 file icons
  provideFileIcons() {
    if (atom.config.get("atom-perl6-editor-tools.fileIconsEnabled")) {
      return new Perl6FileIconsProvider
    }

    return
  },

  // New Perl 6 script
  newP6Script() {
    atom.notifications.addWarning("newP6Script is not implemented!");
  },

  // New Perl 6 project
  newP6Project() {
    atom.notifications.addWarning("newP6Project is not implemented!");
  }
}
