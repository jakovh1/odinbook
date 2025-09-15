import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="post-form"
export default class extends Controller {
  static targets = ["textInput", "fileInput", "submitButton"]
  connect() {
    this.textChanged()
    this.fileChanged()
  }

  textChanged() {
    if (this.textInputTarget.value.trim().length > 0) {
      this.fileInputTarget.disabled = true
      this.submitButtonTarget.disabled = false
    } else {
      this.fileInputTarget.disabled = false
      this.submitButtonTarget.disabled = true
    }
  }

  fileChanged() {
    if (this.fileInputTarget.files.length > 0) {
      this.textInputTarget.disabled = true
      this.submitButtonTarget.disabled = false
    } else {
      this.textInputTarget.disabled = false
      this.submitButtonTarget.disabled = true
    }
  }
}
