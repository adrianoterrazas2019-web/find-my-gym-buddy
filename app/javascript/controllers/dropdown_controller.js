import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this._handleOutsideClick = (e) => {
      if (!this.element.contains(e.target)) this.close()
    }
    document.addEventListener("click", this._handleOutsideClick)
  }

  disconnect() {
    document.removeEventListener("click", this._handleOutsideClick)
  }

  toggle() {
    this.menuTarget.classList.toggle("hidden")
  }

  close() {
    this.menuTarget.classList.add("hidden")
  }
}
