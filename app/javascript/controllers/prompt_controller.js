import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="prompt"
export default class extends Controller {
  connect() {
    const form = document.getElementById("prompt-form")

    function chooseArticle(word) {
      // Convert the word to lowercase for easier comparison
      word = word.toLowerCase();

      // Check if the word starts with a vowel sound
      if (word.startsWith('a') || word.startsWith('e') || word.startsWith('i') || word.startsWith('o') || word.startsWith('u')) {
        return "an";
      } else {
        return "a";
      }
    }

    form.addEventListener("submit", e => {
      e.preventDefault()
      const formData = new FormData(form);
      const name = formData.get('name');
      const occupation = formData.get('occupation');
      const past_tense_verb = formData.get('past_tense_verb');
      const negative_adjective = formData.get('negative_adjective');
      const promptContainer = document.getElementById("prompt-container")
      const prompt = document.createElement('p')
      prompt.innerText = `${name} was ${chooseArticle(occupation)}  ${occupation} and every day ${name} ${past_tense_verb} until something ${negative_adjective} happened`
      promptContainer.append(prompt)
    })
  }
}
