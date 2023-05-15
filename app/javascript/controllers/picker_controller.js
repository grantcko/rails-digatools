import { Controller } from "@hotwired/stimulus"
const faker = require('faker');

// Connects to data-controller="picker"
export default class extends Controller {
  connect() {
    console.log("working");
    const picker = document.getElementById("picker-box");
    function randomizeColor() {
      console.log(picker);
      const hexCode = document.getElementById("hex-code")
      if (picker) {
        let randomColor = faker.internet.color();
        picker.style.backgroundColor = randomColor;
        console.log(randomColor);
        hexCode.innerText = randomColor;
      } else {
        console.log("The element with the ID 'picker-box' does not exist.");
      }
    }

    picker.addEventListener("click", randomizeColor);
  }
}
