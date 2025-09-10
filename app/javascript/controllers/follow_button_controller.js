import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="follow-button"
export default class extends Controller {
  connect() {
    
  }
  hover(event) {
    const element = event.target
    element.dataset.originalText = element.innerHTML.trim()

    switch(element.innerHTML.trim()) {
      case "Pending":
        element.innerHTML = "Cancel";
        break;
      case "Following":
        element.innerHTML = "Unfollow"
        break;
    }

  }

  reset(event) {
    event.target.innerHTML = event.target.dataset.originalText
  }
}
