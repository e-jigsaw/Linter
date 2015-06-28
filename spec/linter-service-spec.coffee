Linter = require('../lib/linter-plus.coffee')
LinterService = require('../lib/linter-service.coffee')

class MockLinter extends Linter
  setupSubscriptions: -> return undefined

describe 'LinterService', ->
  [ linterPlus, service ] = []

  beforeEach ->
    linterPlus = new MockLinter
    service = new LinterService(linterPlus)

  describe 'onDidChangeProjectMessages', ->

    it 'will return a disposable that triggers when linter deactivates', ->
      disposable = service.onDidChangeProjectMessages(->)
      expect(disposable.disposed).toBe(false)

      linterPlus.deactivate()
      expect(disposable.disposed).toBe(true)

  describe 'observeEditorLinters', ->

    it 'will return a disposable that triggers when linter deactivates', ->
      disposable = service.observeEditorLinters(->)
      expect(disposable.disposed).toBe(false)

      linterPlus.deactivate()
      expect(disposable.disposed).toBe(true)

  describe 'Project Messages', ->

    linter = {
      grammarScopes: [ 'fake.txt' ]
      lintOnFly: true
      lint: -> return undefined
    }
    messages = [{
      type: 'Error',
      text: 'testing',
      filePath: 'somefile.txt',
    }, {
      type: 'Error',
      text: 'Second Error',
      filePath: 'somefile.txt',
    }]

    beforeEach ->
      linterPlus.addLinter(linter)

    it 'You can get/set/delete', ->

      changeSpy = jasmine.createSpy('onDidChangeProjectMessages')

      expect(service.getProjectMessages().size).toBe(0)
      service.onDidChangeProjectMessages(changeSpy)

      service.setProjectMessages(linter, messages)

      expect(changeSpy.callCount).toBe(1)
      expect(service.getProjectMessages().size).toBe(2)

      service.setProjectMessages(linter, [])
      expect(changeSpy.callCount).toBe(2)
      expect(service.getProjectMessages().size).toBe(0)

      service.setProjectMessages(linter, [messages[0]])
      expect(changeSpy.callCount).toBe(3)
      expect(service.getProjectMessages().size).toBe(1)

      service.deleteProjectMessages(linter)
      expect(changeSpy.callCount).toBe(4)
      expect(service.getProjectMessages().size).toBe(0)
