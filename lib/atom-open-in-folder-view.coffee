path = require 'path'
fs = require 'fs'
packagePath = atom.packages.resolvePackagePath('fuzzy-finder')
FuzzyFinderView = require path.join(packagePath, 'lib', 'fuzzy-finder-view')
FileList = require './file-list'

module.exports =
class AtomOpenInFolderView extends FuzzyFinderView
  initialize: () ->
    super

  toggle: ->
    if @panel?.isVisible()
      @cancel()
    else
      editor = atom.workspace.getActiveTextEditor()
      paths = (new FileList).getListOfFiles()
      if paths.length > 0
        @setItems paths
      @show()

  getEmptyMessage: (itemCount) ->
    if itemCount is 0
      'There are no other files in this directory'
    else
      super
