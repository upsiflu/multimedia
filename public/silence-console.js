/*---- Custom Element ----
 * Clears the console after 2 seconds. Shameless.
 */

customElements.define(
  "silence-console",
  class extends HTMLElement {
    constructor() {
      super();
    }

    connectedCallback() {
      console.log = () => { };
      setTimeout(() => { console.clear(); }, 2000)
    }
  }
);
