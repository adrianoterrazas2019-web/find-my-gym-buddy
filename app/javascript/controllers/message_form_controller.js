import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea", "submit"]

  disable() {
    this.textareaTarget.readOnly = true
    this.submitTarget.disabled = true
    this.submitTarget.value = "Waiting for response…"
  }
}
