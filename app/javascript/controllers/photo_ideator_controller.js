import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="photo-ideator"
export default class extends Controller {
  connect() {
    const unhideBtn = document.getElementById("unhide-btn")
    const idea = document.getElementById("idea")

    unhideBtn.addEventListener("click", e => {
      console.log("test");
      e.preventDefault()
      idea.style.display = 'block'
      unhideBtn.style.display = 'none'
    })
  }
}
