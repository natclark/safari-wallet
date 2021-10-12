# Shared Extension Resources

- The `manifest.json` is essentially the extension's configuration file.

- The `popup.html`, `popup.css`, and `popup.js` files are for the native popover UI.

- The `background.js` file can run scripts at the "browser level", outside of any particular tab/window.

- The `content.js` file is the script injected onto the page when the extension is loaded (if it has permissions). It is planned to implement the `window.ethereum` object (EIP-1193 JavaScript API), as well as a simple `window.safariWalelt` interface for opening/closing the wallet popover.
