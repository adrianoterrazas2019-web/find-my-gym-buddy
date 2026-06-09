import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea", "submit"]

  // Enter submits; Shift+Enter inserts a new line as normal
  submitOnEnter(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.element.requestSubmit()
    }
  }

  disable() {
    this.textareaTarget.readOnly = true
    this.submitTarget.disabled = true
    this.submitTarget.value = "Waiting for response…"
  }
}
