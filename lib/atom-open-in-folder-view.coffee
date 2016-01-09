path = require 'path'
fs = require 'fs'
packagePath = atom.packages.resolvePackagePath('fuzzy-finder')
FuzzyFinderView = require path.join(packagePath, 'lib', 'fuzzy-finder-view')

module.exports =
class AtomOpenInFolderView extends FuzzyFinderView
  initialize: () ->
    super

  toggle: ->
    if @panel?.isVisible()
      @cancel()
    else
      editor = atom.workspace.getActiveTextEditor()
      paths = []
      if editor
        dirPath = editor.getDirectoryPath()
        fs.readdir(dirPath,
          ((err, files) ->
            paths = (path.join(dirPath, file) for file in files) if not err
            if paths.length > 0
              @setItems paths
              @show()).bind(this)
        )
