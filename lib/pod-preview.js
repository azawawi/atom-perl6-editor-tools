"use babel";

fs                    = require('fs')
Buffer                = require('buffer').Buffer
let {BufferedProcess, CompositeDisposable, Disposable} = require('atom')
let {$, $$$, ScrollView}  = require('atom-space-pen-views')
path                  = require('path')
os                    = require('os')
tmp                   = require('tmp')

module.exports =
class PodPreviewView extends ScrollView {

  constructor({editorId, filePath}) {
    super()

    this.editorId  = editorId;
    this.filePath  = filePath;

    this.editorSub = null
    this.onDidChangeTitle    = new Disposable()
    this.onDidChangeModified = new Disposable()

    if(this.editorId) {
      this.resolveEditor(this.editorId)
      this.tmpPath = this.getPath() // after resolveEditor
    } else {
      if (atom.workspace) {
        this.subscribeToFilePath(filePath)
      } else {
        atom.packages.onDidActivatePackage( () => {
          return this.subscribeToFilePath(filePath)
        })
      }
    }

    atom.deserializers.add(this)
  }

  deserialize(state) {
    return new PodPreviewView(state)
  }

  static content() {
    return this.div( { class: 'atom-perl6-editor-tools native-key-bindings', tabindex: -1 } )
  }

  serialize() {
    return {
      deserializer : 'PodPreviewView',
      filePath     : this.getPath(),
      editorId     : this.editorId
    }
  }

  destroy() {
    if(this.editorSub) {
      this.editorSub.dispose() 
    }
  }

  subscribeToFilePath(filePath) {
    this.trigger('title-changed')
    this.handleEvents()
    this.renderHTML()
  }

  resolveEditor(editorId) {
    resolve = () => {
      this.editor = this.editorForId(editorId)

      if (this.editor) {
        this.trigger('title-changed')
        this.handleEvents()
      } else {
        // The editor this preview was created for has been closed so close
        // this preview since a preview cannot be rendered without an editor
        if(atom.workspace && atom.workspace.paneForItem(this)) {
          atom.workspace.paneForItem(this).destroyItem(this)
        }
      }
    }
    if (atom.workspace) {
      resolve()
    } else {
      atom.packages.onDidActivatePackage( () => {
        resolve()
        this.renderHTML()
      });
    }
  }

  editorForId(editorId) {
    for (editor of atom.workspace.getTextEditors()) {
      if (editor.id && editor.id.toString() == editorId.toString()) {
        return editor
      }
    }

    return null
  }

  handleEvents() {

    changeHandler = () => {
      this.renderHTML()
      pane = atom.workspace.paneForURI(this.getURI())
      if (pane && pane != atom.workspace.getActivePane()) {
        pane.activateItem(this)
      }
    }

    this.editorSub = new CompositeDisposable

    if (this.editor) {
      this.editorSub.add( editor.onDidStopChanging(changeHandler) )
      this.editorSub.add(
        editor.onDidChangePath( 
          () => { this.trigger('title-changed') }
        ) 
      )
    }
  }
  
  renderHTML() {
    if (this.editor) {
      this.renderHtmlCode()
    }
  }

  // Renders the Perl 6 code to HTML via Pod::To::Html
  renderPod6Html(onSuccess) {
    self        = this

    tmp.file( (err, path, fd, cleanupCallback) => {
      if (err) {
        throw err 
      }

      onP6TempFileSaved = (err) => {
        // throw an exception on file save failure
        if (err) {
          throw err 
        }

        // Generate HTML from Perl 6 POD
        //TODO take command from config parameter
        command   = 'perl6'
        args      = ['--doc=HTML', path]
        stdout  = (output) => {
          onSuccess(output)
          return
        }
        stderr  = (output) => {
          console.warn(output)
          return
        }
        exit    = (code) => {
          if (code != 0) {
            atom.notifications.addWarning("Failed to create POD Preview content")
          }
          return
        }
        // Run perl6 --doc=HTML [temp-file-name]
        process   = new BufferedProcess({command, args, stdout, stderr, exit})
        return
      }

      // Write a snapshot of the Perl 6 editor in a temporary file
      buf = new Buffer(this.editor.getText())
      fs.write(fd, buf, 0, buf.length, onP6TempFileSaved)
    })
    return
  }

  save(onHtmlSaved) {
    onPod6HtmlReady = (html) => {
      tmp.file( (err, path, fd, cleanupCallback) => {
        if (err) {
          throw err 
        }
        // Add base tag to allow relative links to work despite being loaded
        // as the src of an iframe
        css = this.makeCssStyles()

        html = html.replace(
          '<link rel="stylesheet" href="//design.perl6.org/perl.css">',
          `<style>${css}</style>`
        )
        modifiedHtml = "<base href=\"" + this.getPath() + "\">" + html
        this.tmpPath = path

        // Write the modified generated HTML in a temporary file
        buf = new Buffer(modifiedHtml)
        fs.write(fd, buf, 0, buf.length, onHtmlSaved)

        return
      })
      return
    }

    this.renderPod6Html(onPod6HtmlReady)
    return
  }

  renderHtmlCode(text) {
    if (this.editor.getPath()) {
      this.save( () => {
        iframe = document.createElement("iframe")

        // Allows for the use of relative resources (scripts, styles)
        iframe.setAttribute("sandbox", "allow-scripts allow-same-origin")
        iframe.src = this.tmpPath
        this.html($(iframe))
        atom.commands.dispatch('main', 'html-changed')
      })
    }
  }

  getTitle() {
    if (this.editor) {
      return `${this.editor.getTitle()} - POD Preview`
    } else {
      return "POD Preview"
    }
  }

  getURI() {
    return `pod-preview://editor/${this.editorId}`
  }

  getPath() {
    return this.editor ? this.editor.getPath() : null
  }

  showError(result) {
    this.html( $$$( () => {
      this.h2('POD Preview Failed')
      failureMessage = result ? result.message : 0
      if (failureMessage) {
        this.h3(failureMessage)
      }
    }))
  }

  makeCssStyles() {
    let myStyle
    for (style of atom.styles.getStyleElements()) {
      if (style.textContent.indexOf('atom-perl6-editor-tools') == -1) {
        continue
      }
      myStyle = style.textContent
    }
    if (!myStyle) {
      console.warn("Failed to get style")
      return ''
    }
    results = []
    regex = /\.atom-perl6-editor-tools\siframe\.(\w+\s*\{\s*(.|\s)+?\})/g
    while (match = regex.exec(myStyle)) {
      results.push(match[1])
    }
    css = results.join("\n")
    return css
  }
}
