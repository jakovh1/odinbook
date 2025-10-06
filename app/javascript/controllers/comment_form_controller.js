import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment-form"
export default class extends Controller {
  static targets = ["commentInput", "submitButton"]
  clear(e) {
    this.element.reset();
    this.commentInputTarget.style.height = 'auto'
    const modal = e.target.dataset.commentFormModal
    console.log(modal)
  
    if (modal) {
      this.close()
    }
  }

  close() {
    const modal = document.getElementById("comment-modal");
    modal.removeAttribute('src');
    modal.removeAttribute('complete');
    modal.innerHTML = "";
  }

  buttonClose(e) {
    e.preventDefault()
    this.close()
  }

  commentInputChanged() {
    this.submitButtonTarget.disabled = this.commentInputTarget.value.trim() == ''
    this.commentInputTarget.style.height = 'auto'
    this.commentInputTarget.style.height = this.commentInputTarget.scrollHeight + "px"
  }

}
