import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tools"
export default class extends Controller {
  connect() {
    const deleteIcon = document.getElementsByClassName("delete");
    console.log(deleteIcon);
    Array.from(deleteIcon).forEach(icon => {
      icon.addEventListener('click', function() {
        console.log(icon.id);
        fetch(`/tools/${icon.id}`, {method: "DELETE"})
        icon.innerHTML = "deleted successfully"
      })
    });
  }
}
