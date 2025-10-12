import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["radio", "specs"];

  connect() {
    this.update();
  }

  update() {
    const selected = this.radioTargets.find((r) => r.checked);
    const slug = selected?.dataset.slug;

    this.specsTargets.forEach((fields) => {
      fields.disabled = fields.hidden = fields.dataset.type != slug;
    });
  }
}
