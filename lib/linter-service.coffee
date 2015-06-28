{Disposable} = require('atom')

module.exports = class LinterService

  constructor: (@linter) ->

  onDidChangeProjectMessages: (callback) ->
    return @linter.onDidChangeProjectMessages(callback)

  getProjectMessages: ->
    return @linter.getProjectMessages()

  setProjectMessages: (linter, messages) ->
    @linter.setProjectMessages(linter, messages)

  deleteProjectMessages: (linter) ->
    @linter.deleteProjectMessages(linter)

  getActiveEditorLinter: ->
    return @linter.getActiveEditorLinter()

  getEditorLinter: (editor) ->
    return @linter.getEditorLinter(editor)

  eachEditorLinter: (callback) ->
    @linter.eachEditorLinter(callback)

  observeEditorLinters: (callback) ->
    return @linter.observeEditorLinters(callback)
