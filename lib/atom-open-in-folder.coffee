AtomOpenInFolderView = require './atom-open-in-folder-view'
{CompositeDisposable} = require 'atom'

module.exports = AtomOpenInFolder =
  atomOpenInFolderView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @atomOpenInFolderView = new AtomOpenInFolderView(state.atomOpenInFolderViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @atomOpenInFolderView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-open-in-current-folder:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @atomOpenInFolderView.destroy()

  serialize: ->
    atomOpenInFolderViewState: @atomOpenInFolderView.serialize()

  toggle: ->
    console.log 'AtomOpenInFolder was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
