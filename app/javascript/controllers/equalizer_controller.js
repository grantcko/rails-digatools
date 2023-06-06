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
    const submitButton = document.getElementById("eq-submit");

    function link_file() {
      console.log("submitted");
      downloadLink.textContent = 'DOWNLOAD';
      downloadLink.href = "/download/?file=RackMultipart20230605-4357-6wchad.wav_output.wav";
      console.log(downloadLink);
      // append a download link to the new file
      container.insertBefore(downloadLink, eqForm)
      // delete the file after downloaded
    };

    // run fuction when user submits the form
    submitButton.addEventListener("click", link_file,);
  }
}
