window.$ = window.jQuery = require('../node_modules/jquery')
AtomSkypagerView = require './atom-skypager-view'


{CompositeDisposable} = require 'atom'

module.exports = AtomSkypager =
  AtomSkypagerView: null
  modalPanel: null
  subscriptions: null
  enlarged : false
  isWindowResizingAllowed : false

  config:
    atomSkypagerUrl:
      type: 'string'
      default: 'http://localhost:9001'

  activate: (state) ->
    @AtomSkypagerView = new AtomSkypagerView(state.AtomSkypagerViewState)
    @modalPanel = atom.workspace.addRightPanel(item: @AtomSkypagerView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-skypager:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-skypager:enlarge': => @enlarge()

    $(document).ready ->
      height = $(window).height()
      width = $(window).width()
      $('.atom-skypager').width(width / 2.5)
      $('.atom-skypager').append('<webview id="atom-skypager" src="' + atom.config.get('atom-skypager.atomSkypagerUrl') + '"></webview>')
      $(window).on 'resize' , ->
        if @isWindowResizingAllowed
          width = $(window).width()
          if @enlarged
            $('.atom-skypager').width(width / 2)
          else
            $('.atom-skypager').width(width / 2.5)



  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @AtomSkypagerView.destroy()

  serialize: ->
    AtomSkypagerViewState: @AtomSkypagerView.serialize()

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  enlarge: ->
    @isWindowResizingAllowed = false
    if @enlarged == false
      $('.atom-skypager').width($(window).width() / 2)
      @enlarged = true
    else
      $('.atom-skypager').width($(window).width() / 2.5)
      @enlarged = false
    @isWindowResizingAllowed = true
