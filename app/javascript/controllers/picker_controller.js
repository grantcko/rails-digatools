import { Controller } from "@hotwired/stimulus"
const faker = require('faker');

// Connects to data-controller="picker"
export default class extends Controller {
  connect() {
    const picker = document.getElementById("picker-box");
    console.log(picker);
    const hexCopyBar = document.querySelector(".hex-copy-bar");
    const hexCode = document.getElementById("hex-code");
    const copyNotifications = document.querySelectorAll(".copy-notification");
    const colorWheel = document.querySelector(".colorwheel");


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
        copyNotification.innerText = "☑";
      });

      setTimeout(() => {
        copyNotifications.forEach(copyNotification => {
          console.log("timeout completed");
          copyNotification.innerText = "⎗";
        });
      }, "2000");
    }

    function rgbToHex(r, g, b) {
      var rHex = r.toString(16);
      var gHex = g.toString(16);
      var bHex = b.toString(16);

      if (rHex.length == 1) rHex = "0" + rHex;
      if (gHex.length == 1) gHex = "0" + gHex;
      if (bHex.length == 1) bHex = "0" + bHex;

      return "#" + rHex + gHex + bHex;
    }

    function getPixelColor(img, event) {
      console.log(img);
      // Create a temporary canvas to draw the image on.
      var canvas = document.createElement("canvas");
      var ctx = canvas.getContext("2d");
      canvas.width = img.width;
      canvas.height = img.height;
      console.log(canvas.width);
      console.log(canvas.height);

      ctx.drawImage(img, 0, 0, canvas.width, canvas.height);

      // Get the image position and size.
      var rect = img.getBoundingClientRect();
      var width = img.width;
      var height = img.height;

      // Calculate the position of the click relative to the image.
      var x = event.clientX - rect.left;
      var y = event.clientY - rect.top;

      console.log(x);
      console.log(y);

      // Scale the position to match the image resolution.
      x = Math.round((x / rect.width) * width);
      y = Math.round((y / rect.height) * height);

      // Get the color data of the clicked pixel.
      var pixelData = ctx.getImageData(x, y, 1, 1).data;
      console.log(pixelData);
      var r = pixelData[0];
      var g = pixelData[1];
      var b = pixelData[2];

      // return rgb values as a hex string eg. #ff000
      // return `{rgb({r}, ${g}, ${b})}`
      return rgbToHex(r, g ,b)
    }

    function setColor(hexValue) {
      picker.style.backgroundColor = hexValue;
      hexCode.innerText = hexValue;
    }

    picker.addEventListener("click", randomizeColor);
    hexCopyBar.addEventListener("click", copyText);
    colorWheel.addEventListener("click", function(event) {
      var color = getPixelColor(colorWheel, event);
      setColor(color);
    });
  }
}
