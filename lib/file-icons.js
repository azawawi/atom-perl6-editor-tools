"use babel";

fs = require('fs-plus')
path = require('path')

/**
 * This class provides the file-icons service API implemented by tree-view
 * Please see https://github.com/atom/tree-view#api
 */
module.exports =
class Perl6FileIconsProvider {

  iconClassForPath(filePath) {
    extension = path.extname(filePath)

    if (fs.isSymbolicLinkSync(filePath)) {
      return 'icon-file-symlink-file'
    } else if (fs.isReadmePath(filePath)) {
      return 'icon-book'
    } else if (fs.isCompressedExtension(extension)) {
      return 'icon-file-zip'
    } else if (fs.isImageExtension(extension)) {
      return 'icon-file-media'
    } else if (fs.isPdfExtension(extension)) {
      return 'icon-file-pdf'
    } else if (fs.isBinaryExtension(extension)) {
      return 'icon-file-binary'
    } else if (extension == ".pm6" ||
               extension == ".pm"  ||
               extension == ".pl6" ||
               extension == ".p6"  ||
               extension == ".pl"  ||
               extension == ".t") {
      return 'icon-file-perl6'
    }
    else {
      return 'icon-file-text'
    }
  }
  
  onWillDeactivate(fn) {
    // Workaround to Issue #732: Tree-view API is not being called on startup
    // https://github.com/atom/tree-view/issues/732
    leftPanels = atom.workspace.getLeftPanels();
    if (   leftPanels
        && leftPanels.length > 0
        && typeof leftPanels[0].item == "object"
        && typeof leftPanels[0].item.updateRoots == "function")
    {
      atom.workspace.getLeftPanels()[0].item.updateRoots()
    }

    return
  }
}