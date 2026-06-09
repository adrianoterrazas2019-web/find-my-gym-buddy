import { Controller } from "@hotwired/stimulus"

// Submits the form element as soon as it enters the DOM.
// Used to chain a second HTTP action (POST /pairings) after a Turbo Stream
// response without requiring any user interaction.
export default class extends Controller {
  connect() {
    this.element.requestSubmit()
  }
}
