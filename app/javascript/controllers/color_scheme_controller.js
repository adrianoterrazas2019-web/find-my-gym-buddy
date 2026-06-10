import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { current: String }

  connect() {
    this.currentValue = localStorage.getItem("colorTheme") || "orange"
    this._apply(this.currentValue)
  }

  select({ params: { theme } }) {
    this.currentValue = theme
    this._apply(theme)
    localStorage.setItem("colorTheme", theme)
  }

  currentValueChanged(value) {
    this.element.querySelectorAll("[data-color-scheme-theme-param]").forEach(el => {
      const active = el.dataset.colorSchemeThemeParam === value
      el.style.boxShadow = active
        ? "0 0 0 2px var(--gym-bg), 0 0 0 4px var(--gym-text)"
        : ""
      el.style.transform = active ? "scale(1.15)" : ""
    })
  }

  _apply(theme) {
    document.documentElement.dataset.theme = theme
    window.dispatchEvent(new CustomEvent("colorscheme:changed"))
  }
}
