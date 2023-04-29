const { createApp } = Vue;

createApp({
  data() {
    return {
      message: "",
      visible: false,
      mod: 0.1,
      storage: {}
    };
  },
  mounted() {
    window.addEventListener("message", this.onMessage);
  },
  destroyed() {
    window.removeEventListener("message");
  },
  methods: {
    onMessage(event) {
      if (event.data.type === "open") {
        this.visible = true;
        this.storage = event.data.storage
      }
      if (event.data.type === "close") {
        this.visible = false;
      }

      if (event.data.type === 'update') { 
        this.storage = event.data.storage
      }
    },
    press(what, type) {
      fetch(`https://${GetParentResourceName()}/pressed`, {
        method: "POST",
        body: JSON.stringify({
          type: type,
          what: what,
          mod: this.mod
        })
      });
    },
    focus() {
      fetch(`https://${GetParentResourceName()}/focus`, {
        method: "POST",
      });
    },
    stop() {
      this.visible = false
      fetch(`https://${GetParentResourceName()}/stop`, {
        method: "POST",
      });
    }
  },
}).mount("#app");
