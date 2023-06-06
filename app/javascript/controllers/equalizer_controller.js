import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="equalizer"
export default class extends Controller {
  connect() {
    const downloadLink = document.createElement('a');
    // select auto equalizer form
    const eqForm = document.getElementById("equalize-form");

    // run fuction when user submits the form
    eqForm.addEventListener("submit", submit,);

    function submit(event) {
      console.log("submitted");
      event.preventDefault();
      // downloadLink.textContent = 'DOWNLOAD';
      // downloadLink.href = "/download/?file=test_output.wav";
      // console.log(downloadLink);
      // // append a download link to the new file
      // container.insertBefore(downloadLink, eqForm)
      // // delete the file after downloaded
    };
  }
}
