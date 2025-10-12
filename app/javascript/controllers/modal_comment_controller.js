import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal-comment"
export default class extends Controller {
  static targets = ["modalClose"]

  connect() {
    
    requestAnimationFrame(() => {
      this.element.children[0].classList.add("fade-in")
    })
  }

  close() {
    const modal = document.getElementById("comment-modal");
    modal.removeAttribute('src');
    modal.removeAttribute('complete');
    modal.innerHTML = "";
  }

  buttonClose(e) {
    this.element.children[0].addEventListener("transitionend", () => {
      this.close()
    }, { once: true})

    e.preventDefault()   
    this.element.children[0].classList.add("fade-out")
  }
}
