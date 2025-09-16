import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="upload-avatar"
export default class extends Controller {
  static targets = [ "fileInput", "form" ]
  connect() {
  }
  
  fileChanged() {
    if (this.fileInputTarget.files[0]) {
      this.formTarget.requestSubmit()
    }
  }
}
