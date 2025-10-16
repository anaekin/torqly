import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["radio", "specs"];

  connect() {
    this.update();
  }

  update() {
    const selected = this.radioTargets.find((r) => r.checked);
    const slug = selected?.dataset.slug;

    this.specsTargets.forEach((section) => {
      const show = section.dataset.type === slug;

      section.classList.toggle("d-none", !show);

      section
        .querySelectorAll("input, select, textarea, button, radio")
        .forEach((el) => {
          el.disabled = !show;
        });
    });
  }
}
