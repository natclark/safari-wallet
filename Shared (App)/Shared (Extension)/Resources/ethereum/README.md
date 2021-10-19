# safari-wallet-ethereum

**Warning: Do not edit or remove the `dist.js` or `dist.js.map` files directly!**

This is the wallet's EIP-1193 implementation of the `window.ethereum` object, which is injected into web pages where the extension is active.

The `dist.js` file exports the `window.ethereum` object to the `../content.js` file, which injects it into the page.

## Install

```sh
npm i
```

## Build dist.js

```sh
npm run build
```
