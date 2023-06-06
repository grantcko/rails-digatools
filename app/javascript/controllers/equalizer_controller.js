import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="equalizer"
export default class extends Controller {
  connect() {
    const container = document.getElementById('equalizer-container');
    const downloadLink = document.createElement('a');
    // select auto equalizer form
    const eqForm = document.getElementById("equalize-form");

    // run fuction when user submits the form
    eqForm.addEventListener("submit", submit,);

    function submit(event) {
      // send form data to server for eq processing + add link to the output file
      console.log("submitted");
      event.preventDefault();

      const formData = new FormData(event.target);
      fetch("/equalize", {method: "POST", body: formData})
      .then(function(response) {
        console.log("post request sent");
        console.log(response);
        return response.json();
      })
      .then(function(data) {
        console.log(`this is the output file name: ${data.output}`);
        downloadLink.textContent = `⬇️ ${data.output} ⬇️`;
        downloadLink.href = `/download/?file=${data.output}`;
        console.log(`this is the download link: ${downloadLink}`);
        container.insertBefore(downloadLink, eqForm)
      });
    };
  }
}
