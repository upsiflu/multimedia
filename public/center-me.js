/*---- Custom Element ----
 * Centers itself smoothly into the viewport
 */

customElements.define(
  "center-me",
  class extends HTMLElement {
    constructor() {
      super();
    }

    connectedCallback() {
      window.requestAnimationFrame(() => this.scrollIntoView({ behavior: "smooth", block: "start", inline: "center" }));
    }

    static get observedAttributes() {
      return ["hash"];
    }
  }
);
