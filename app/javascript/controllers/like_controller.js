import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="like"
export default class extends Controller {
  connect() {
  }

  async like() {
    const initialState = [...this.element.children].map(child => child.cloneNode(true))

    if (this.element.dataset.liked == "false") {
      this.renderFilledHeart(Number(this.element.children[1].innerHTML.trim()))

      const response = await fetch(`/posts/${this.element.dataset.postId}/like`, {
        method: 'POST',
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
        }
      })

      if (!response.ok) {
        this.element.replaceChildren(...initialState)
      }
    } else if (this.element.dataset.liked == "true") {
      this.renderEmptyHeart(Number(this.element.children[1].innerHTML.trim()))

      const response = await fetch(`/posts/${this.element.dataset.postId}/dislike`, {
        method: 'DELETE',
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
        }
      })

      if (!response.ok) {
        this.element.replaceChildren(...initialState)
      }
    }

    
  }

  renderEmptyHeart(likeCount) {
    const newLikeCount = likeCount - 1
    this.element.dataset.liked = "false"
    this.element.classList.remove("liked")
    this.element.classList.add("unliked")
    this.element.title = "Like this Post."
    const newInnerHTML = `<i class="bi bi-heart"></i>
                          <span>${newLikeCount}</span>`
    this.element.innerHTML = newInnerHTML
  }

  renderFilledHeart(likeCount) {
    const newLikeCount = likeCount + 1
    this.element.dataset.liked = "true"
    this.element.classList.remove("unliked")
    this.element.classList.add("liked")
    this.element.title = "Unlike this Post."
    const newInnerHTML = `<i class="bi bi-heart-fill liked"></i>
                          <span>${newLikeCount}</span>`
    this.element.innerHTML = newInnerHTML
  }

}
