# Safari Wallet

This is an experiment to see whether we can build a viable browser extension Ethereum wallet for Safari on macOS and especially iOS.

## Overview

A diagram might be useful, but basically the current plan/rundown is:

- The `window.ethereum` object (EIP-1193 JavaScript API) will be injected into each page. This way, the wallet will automatically work with all apps/dApps that support MetaMask.

- For the interface, the native Safari extension popover is used, in tandem with the [WebExtensions API](https://developer.mozilla.org/en-US/Add-ons/WebExtensions).

The bulk of the development is currently going on in the `Shared (Extension)` folder.

It is important to read these files:

- `Shared Extension (Popover)` > `Resources` > `README.md`

- `test-dapp` > `README.md`

## Popover

### Setting up the popover

1. Open this repo as a project in Xcode

2. In the leftmost top bar breadcrumb, which should be on "macOS" by default, switch it to "iOS"

3. Set the following breadcrumb to a mobile device, perhaps "iPhone 13 Pro"?

4. Click the play button to start the emulator

5. Once the emulator has loaded (it might take a few minutes), open the Settings app

6. Settings > Safari > Extensions > Wallet Extension

7. Switch to on

Then, to test the popover, navigate to https://safari-wallet-test-dapp.vercel.app in Safari (or http://localhost:3000/, if you're running the local dev server)

You can also set up the local dev server here (WIP): https://github.com/natclark/safari-wallet-test-dapp
