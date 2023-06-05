import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="equalizer"
export default class extends Controller {
  connect() {
    // TODO
    // select auto equalizer submit button
    const myForm = document.getElementById("equalize");
    // run fuction when user submits the form
    myForm.addEventListener("submit", link_file);
    function link_file() {
      // append a download link to the new file
      const container = document.getElementById("equalizer-container");
      const downloadLink = document.createElement('a');
      downloadLink.textContent = 'DOWNLOAD';
      downloadLink.href = `equalized_audio/${gon.output_path}`;
      console.log(container);
      console.log(downloadLink);
      // insertAfter(downloadLink, container)
      // delete the file after downloaded
    };
  }
}
