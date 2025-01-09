// assets/js/hooks/plaid_hook.js

export default {
    mounted() {
      const linkToken = this.el.getAttribute("data-link-token");
  
      if (!linkToken) {
        console.error("Plaid link_token is missing!");
        return;
      }
  
      const handler = Plaid.create({
        token: linkToken,
        onSuccess: (public_token, metadata) => {
          // Send the public_token and metadata back to the LiveView server
          // this.pushEvent("plaid_success", { public_token, metadata });
          this.pushEvent("plaid_success", { public_token});

        },
        onExit: (err, metadata) => {
          if (err) {
            console.error("Plaid Link exited with error:", err);
          } else {
            console.log("Plaid Link exited successfully:", metadata);
          }
        },
        onEvent: (eventName, metadata) => {
          console.log("Plaid event:", eventName, metadata);
        }
      });
  
      // Open Plaid Link when the button is clicked
      this.el.addEventListener("click", () => handler.open());
    }
  };
  