import { Controller } from "@hotwired/stimulus"
const faker = require('faker');

// Connects to data-controller="picker"
export default class extends Controller {
  connect() {
    const picker = document.getElementById("picker-box");
    const hexCopyBar = document.querySelector(".hex-copy-bar");
    const hexCode = document.getElementById("hex-code");
    const copyNotifications = document.querySelectorAll(".copy-notification");

    function randomizeColor() {
      if (picker) {
        let randomColor = faker.internet.color();
        picker.style.backgroundColor = randomColor;
        hexCode.innerText = randomColor;
      } else {
        console.log("The element with the ID 'picker-box' does not exist.");
      }
    }

    function copyText() {
      navigator.clipboard.writeText(hexCode.innerText);
      copyNotifications.forEach(copyNotification => {
        copyNotification.innerText = "copied!";
      });

      setTimeout(() => {
        copyNotifications.forEach(copyNotification => {
          console.log("timeout completed");
          copyNotification.innerText = "click to copy"
        });
      }, "2000");
    }

    picker.addEventListener("click", randomizeColor);
    hexCopyBar.addEventListener("click", copyText);
  }
}
