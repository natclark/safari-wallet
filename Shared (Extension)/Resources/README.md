# Shared Extension Resources

**Do not edit the `content.js` file in this folder!!** It is built automatically by the Gulp setup in `../Popover`.

- The `manifest.json` is essentially the extension's configuration file.

- The `popup.html`, `popup.css`, and `popup.js` files are for the *native* popover and aren't really used at the moment, in favor of the web view popover in `../Popover`.

- The `background.js` file can run scripts at the "browser level", outside of any particular tab/window.

- The `content.js` file is the script injected onto the page when the extension is loaded (if it has permissions). It is currently built by `../Popover`, and it is planned to implement the `window.ethereum` object (EIP-1193 JavaScript API).
