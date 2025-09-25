import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

// Connects to data-controller="chat"
export default class extends Controller {
  static targets = ["chatId", "messageInput"]

  template(data) {
    return `<p class="${data.author_id == this.element.dataset.subscriberId ? 'sender-message' : 'recipient_message'}">
              ${data.content}
            </p>`
  }
  
  connect() {
    
    this.chatChannel = consumer.subscriptions.create({channel: "ChatChannel", chat_id: this.chatIdTarget.value}, {
      connected: () => {
        // Called when the subscription is ready for use on the server
        document.querySelector('.conversation-container').lastElementChild.scrollIntoView({ behavior: 'auto', block: 'end' })
        this.messageInputTarget.focus({ preventScroll: false, focusVisible: true })
        window.scrollTo({
            top: document.body.scrollHeight,
            behavior: 'smooth'
        });
      },

      disconnected: () => {
        // Called when the subscription has been terminated by the server
      },

      received: (data) => {
        // Called when there's incoming data on the websocket for this channel
        const messageDisplay = document.querySelector('.conversation-container')
        messageDisplay.insertAdjacentHTML('beforeend', this.template(data))
        messageDisplay.lastElementChild.scrollIntoView({ behavior: 'auto', block: 'end' })
      },

    });
  }


  scrollToBottom() {
    document.querySelector('.conversation-container').lastElementChild.scrollIntoView({ behavior: 'auto', block: 'end' })
    this.messageInputTarget.focus({ preventScroll: false, focusVisible: true })
  }

  clearInput() {
    this.messageInputTarget.value = ""
  }

  disconnect() {
    if (this.chatChannel) {
      this.chatChannel.unsubscribe()
    }
  }
}
