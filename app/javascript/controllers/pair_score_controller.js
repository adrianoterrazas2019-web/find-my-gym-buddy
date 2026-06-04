import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["label"]

  updateLabel(event) {
    this.labelTarget.textContent = event.target.value
  }
}
