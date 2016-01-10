path = require 'path'
fs = require 'fs'
{GitRepository} = require 'atom'

module.exports = class FileList
  [repo, ignoredNames] = []

  isIgnored: (rootPath, file) ->
    @ignoredNames = atom.config.get('core.ignoredNames')
    relativePath = path.relative(rootPath, file)
    if @repo?.isPathIgnored(relativePath)
      true
    else
      for ignoredName in @ignoredNames
        return true if ignoredName.match(relativePath)

  getFilesOfDirectory: (dirPath, ignoredFile) ->
    files = []
    allFiles = fs.readdirSync(dirPath)
    for file in allFiles
      currentFile = path.join(dirPath, file)
      if(!ignoredFile || (ignoredFile && currentFile != ignoredFile))
        stats = fs.statSync(currentFile)
        if stats.isFile()
          files.push(currentFile)
        else
          if stats.isDirectory()
            files = files.concat(@getFilesOfDirectory(currentFile, ignoredFile))
    files

  getListOfFiles: () ->
    files = []
    editor = atom.workspace.getActiveTextEditor()
    currentFile = editor?.getPath()
    directories = []
    if editor && currentFile
      directories.push(editor.getDirectoryPath())
    else
      projectDirs = atom.project.getPaths()
      if projectDirs
          directories = directories.concat(projectDirs)
    for directory in directories
      @repo = GitRepository.open(directory, refreshOnWindowFocus: false)
      result = @getFilesOfDirectory(directory, currentFile)
      for file in result
        if !@isIgnored(directory, file)
          files.push(file)
    files
