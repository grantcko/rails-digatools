import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="prompt"
export default class extends Controller {
  connect() {
    const form = document.getElementById("prompt-form")
    console.log(form);
    form.addEventListener("submit", e => {
      e.preventDefault()
      const formData = new FormData(form);
      const name = formData.get('name');
      const occupation = formData.get('occupation');
      const past_tense_verb = formData.get('past_tense_verb');
      const negative_adjective = formData.get('negative_adjective');
      const promptContainer = document.getElementById("prompt-container")
      const prompt = document.createElement('p')
      prompt.innerText = `${name} was a(n)  ${occupation} and every day he/she ${past_tense_verb} until something ${negative_adjective} happened`
      promptContainer.append(prompt)
    })
  }
}
