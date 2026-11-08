import { Controller } from "@hotwired/stimulus"

// Counts down from the seconds the server sent (not the browser's clock),
// then sends the student to the attempt page, where the server closes it.
export default class extends Controller {
  static targets = ["display"]
  static values = { seconds: Number, url: String }

  connect() {
    this.endsAt = Date.now() + this.secondsValue * 1000
    this.tick()
    this.timer = setInterval(() => this.tick(), 1000)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  tick() {
    const left = Math.max(0, Math.ceil((this.endsAt - Date.now()) / 1000))
    const m = String(Math.floor(left / 60)).padStart(2, "0")
    const s = String(left % 60).padStart(2, "0")
    this.displayTarget.textContent = `${m}:${s}`
    if (left <= 0) {
      clearInterval(this.timer)
      window.location.href = this.urlValue
    }
  }
}
