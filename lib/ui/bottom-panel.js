'use babel'

const Interact = require('interact.js')
import {CompositeDisposable} from 'atom'
import {Message} from './message-element'

export class BottomPanel {
  constructor(scope) {
    this.subscriptions = new CompositeDisposable
    this.element = document.createElement('linter-panel') // TODO(steelbrain): Make this a `div`
    this.element.tabIndex = "-1"
    this.panel = atom.workspace.addBottomPanel({item: this.element, visible: false, priority: 500})
    this.visibility = false
    this.scope = scope
    this.messages = new Map()

    this.subscriptions.add(atom.config.observe('linter.showErrorPanel', value => {
      this.configVisibility = value
      this.setVisibility(true)
    }))
    this.subscriptions.add(atom.workspace.observeActivePaneItem(paneItem => {
      this.paneVisibility = paneItem === atom.workspace.getActiveTextEditor()
      this.setVisibility(true)
    }))

    Interact(this.element).resizable({edges: { top: true }})
      .on('resizemove', function (event) {
        var target = event.target;
        if (event.rect.height < 25) {
          if (event.rect.height < 1) {
            target.style.width = target.style.height = null
          } else return // No-Op
        } else {
          target.style.width  = event.rect.width + 'px'
          target.style.height = event.rect.height + 'px'
        }
      })
  }
  refresh(scope) {
    this.scope = scope
    for (let message of this.messages) {
      message[1].updateVisibility(scope)
    }
  }
  setMessages({added, removed}) {
    if (removed.length)
      this.removeMessages(removed)
    for (let message of added) {
      const messageElement = Message.fromMessage(message)
      this.element.appendChild(messageElement)
      messageElement.updateVisibility(this.scope)
      this.messages.set(message, messageElement)
    }
  }
  removeMessages(removed) {
    for (let message of removed) {
      if (this.messages.has(message)) {
        this.element.removeChild(this.messages.get(message))
        this.messages.delete(message)
      }
    }
  }
  getVisibility() {
    return this.visibility
  }
  setVisibility(value) {
    this.visibility = value && this.configVisibility && this.paneVisibility
    if (this.visibility) {
      this.panel.show()
    } else {
      this.panel.hide()
    }
  }
  dispose() {
    this.subscriptions.dispose()
    this.messages.clear()
    this.panel.destroy()
  }
}
