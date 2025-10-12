import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment-form"
export default class extends Controller {
  static targets = ["commentInput", "submitButton"]
  connect() {
    this.submitButtonTarget.addEventListener("transitionend", (event) => {
      event.stopPropagation()
    })
  }
  clear(e) {
    this.element.reset();
    this.commentInputTarget.style.height = 'auto'
    const modal = e.target.dataset.commentFormModal
  
    if (modal) {
      
      this.element.parentElement.addEventListener("transitionend", () => {
        this.close()  
      }, { once: true })

      this.element.parentElement.classList.add("fade-out")
    }
  }

  close() {
    const modal = document.getElementById("comment-modal");
    modal.removeAttribute('src');
    modal.removeAttribute('complete');
    modal.innerHTML = "";
  }

  commentInputChanged() {
    this.submitButtonTarget.disabled = this.commentInputTarget.value.trim() == ''
    this.commentInputTarget.style.height = 'auto'
    this.commentInputTarget.style.height = this.commentInputTarget.scrollHeight + "px"
  }

}
