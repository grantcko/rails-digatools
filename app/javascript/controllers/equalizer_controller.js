import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="equalizer"
export default class extends Controller {
  connect() {
    // select surrounding container
    const container = document.getElementById("equalizer-container");
    // select auto equalizer submit button
    const downloadLink = document.createElement('a');
    // select auto equalizer form
    const eqForm = document.getElementById("equalize");

    // run fuction when user submits the form
    link_file();

    function link_file() {
      console.log("submitted");
      downloadLink.textContent = 'DOWNLOAD';
      downloadLink.href = "";
      console.log(downloadLink);
      // append a download link to the new file
      container.insertBefore(downloadLink, eqForm)
      // delete the file after downloaded
    };
  }
}
