/*---- Custom Element ----
 * Centers itself smoothly horizontally into the viewport.
 * Use inside horizontally scrollable containers such as carousel.
 * In contrast to center-me, the vertical (`block`) direction
 * will only scroll if extending out of the viewport (`nearest`).
 */

customElements.define(
  "center-me-horizontally",
  class extends HTMLElement {
    constructor() {
      super();
    }

    connectedCallback() {
      window.requestAnimationFrame(() => this.scrollIntoView({ behavior: "smooth", block: "nearest", inline: "center" }));
    }

    static get observedAttributes() {
      return ["hash"];
    }
  }
);
