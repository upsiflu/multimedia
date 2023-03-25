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
      const offset = 0 - container.offsetWidth / 2 || 0
      console.log(offset);
      container.style.marginInlineStart = offset + "px";
      const moveBy = delta => {
        container.style.marginInlineStart = (parseInt(container.style.marginInlineStart) + delta) + "px";
        window.requestAnimationFrame(adjust);
      }
      window.addEventListener('resize', () => window.requestAnimationFrame(adjust))
      container.parentElement?.querySelector(".summary")?.addEventListener("click", () => { console.log("clickiiiii"); window.requestAnimationFrame(adjust) })
    }

    static get observedAttributes() {
      return [];
    }
  }
);
