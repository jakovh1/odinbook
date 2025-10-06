import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="post-form"
export default class extends Controller {
  static targets = ["textInput", "filePreview", "fileInput", "submitButton" ]
  connect() {
    this.textChanged()
    this.fileChanged()
  }

  textChanged() {
    this.textInputTarget.style.height = 'auto'
    this.textInputTarget.style.height = this.textInputTarget.scrollHeight + 'px' 
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
      this.previewImage(this.fileInputTarget.files[0], this.filePreviewTarget)
    } else {
      this.textInputTarget.disabled = false
      this.submitButtonTarget.disabled = true
      this.filePreviewTarget.style.display = 'none'
    }
  }

  previewImage(file, previewPlaceholder) {
    if (file.type.startsWith('image/')) {
      const reader = new FileReader()
      reader.onload = function(e) {
        previewPlaceholder.src = e.target.result
        previewPlaceholder.style.display = 'block'
      }
      reader.readAsDataURL(file)
    }
  }
}
