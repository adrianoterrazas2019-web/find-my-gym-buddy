import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const date = new Date(this.element.dateTime)
    if (isNaN(date)) return
    this.element.textContent = date.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })
  }
}
