{CompositeDisposable} = require 'atom'

module.exports = AtomOpenInFolder =
  currentFolderView: null
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-open-in-current-folder:toggle':
      => @createCurrentFolderView().toggle()

  createCurrentFolderView: ->
    unless @currentFolderView?
      AtomOpenInFolderView = require './atom-open-in-folder-view'
      @currentFolderView = new AtomOpenInFolderView()
    @currentFolderView

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @currentFolderView?.destroy()

  serialize: ->
    @currentFolderView?.serialize()
