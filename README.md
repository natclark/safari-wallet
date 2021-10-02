# Safari Wallet

This is an experiment to see whether we can build a viable browser extension Ethereum wallet for Safari on macOS and especially iOS.

## Overview

A diagram might be useful, but basically the current plan/rundown is:

- The `window.ethereum` object (EIP-1193 JavaScript API) will be injected into each page. This way, the wallet will automatically work with all apps/dApps that support MetaMask.

- For the interface, a custom web popover will be used instead of the native Safari extension popover.

The bulk of the development is currently going on in the `Shared (Extension)` folder.

It is important to read these files:

- `Shared Extension (Popover)` > `Popover` > `README.md`

- `Shared Extension (Popover)` > `Resources` > `README.md`

## Popover

### Setting up the popover

1. Open this repo as a project in Xcode

2. In the leftmost top bar breadcrumb, which should be on "macOS" by default, switch it to "iOS"

3. Set the following breadcrumb to a mobile device, perhaps "iPhone 13 Pro"?

4. Click the play button to start the emulator

5. Once the emulator has loaded (it might take a few minutes), open the Settings app

6. Settings > Safari > Extensions > Wallet Extension

7. Switch to on

Then, to test the popover, navigate to https://safari-wallet-test-dapp.pages.dev in Safari (or http://localhost:3000/test-dapp/, if you're running the local dev server)

### Developing the popover

To work on the popover, there are instructions for setting up a local development server with Gulp in `Shared (Extension)` > `Popover` > `README.md`.

Once the popover is built, it can be tested using the emulator (or by connecting a physical device with iOS 15). Instructions for running the build process are in the aforementioned README file.
