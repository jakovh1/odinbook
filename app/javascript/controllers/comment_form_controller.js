import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="comment-form"
export default class extends Controller {
  clear(e) {
    this.element.reset();
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

}
