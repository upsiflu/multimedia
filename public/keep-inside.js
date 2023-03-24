/*---- Custom Element ----
 * Centers itself smoothly into the viewport
 */

customElements.define(
  "keep-inside",
  class extends HTMLElement {
    constructor() {
      super();
    }

    connectedCallback() {
      const container = this.parentElement;
      const adjust = () => {
        const bounds = container.getBoundingClientRect();
        if (bounds.left < 0)
          moveBy(1);
        if (bounds.right > window.innerWidth)
          moveBy(-1);
      }
      const moveBy = delta => {
        container.style.left = (parseInt(container.style.left || "0") + delta) + "px";
        window.requestAnimationFrame(adjust);
      }
      adjust();
      window.addEventListener('resize', () => window.requestAnimationFrame(adjust))
    }

    static get observedAttributes() {
      return [];
    }
  }
);
