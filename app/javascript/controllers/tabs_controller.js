import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    const forced = this.element.dataset.tabsActiveTab
    this.show(forced || this.defaultTab)
  }

  switch(event) {
    this.show(event.params.tab)
  }

  show(name) {
    this.panelTargets.forEach(panel => {
      panel.hidden = panel.dataset.tabName !== name
    })
    this.tabTargets.forEach(tab => {
      const active = tab.dataset.tabName === name
      tab.setAttribute("aria-selected", active)
      tab.classList.toggle("tab-btn-active", active)
      tab.classList.toggle("tab-btn-inactive", !active)
    })
  }

  get defaultTab() {
    const first = this.panelTargets.find(p => !p.hidden)
    return first ? first.dataset.tabName : this.panelTargets[0]?.dataset.tabName
  }
}
