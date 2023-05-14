import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="picker"
export default class extends Controller {
  connect() {
    const picker = document.getElementById("picker-box");
    function logPicker() {
      console.log(picker);
    }
    picker.addEventListener("click", logPicker);
  }
}
