// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails";
import "controllers";

document.addEventListener("turbo:load", () => {
  if (!window.mdb) {
    return;
  }

  document.querySelectorAll(".dropdown-toggle").forEach((el) => {
    mdb.Dropdown.getOrCreateInstance(el);
  });
});
