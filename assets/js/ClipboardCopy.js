let Hooks = {};

Hooks.ClipboardCopy = {
  mounted() {
    this.el.addEventListener("click", () => {
      const textToCopy = this.el.getAttribute("data-clipboard");

      navigator.clipboard.writeText(textToCopy)
        .then(() => {
          console.log("Copied to clipboard!");
        })
        .catch(err => {
          console.error("Failed to copy: ", err);
        });
    });
  }
};

export default Hooks;
