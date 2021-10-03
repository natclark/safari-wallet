# Popover

Rather than a native iOS extension popover, this wallet uses a web view popover for more flexibility.

The source for this custom web view popover is in the `src` folder. The `window.ethereum` object will also be implemented there.

Gulp is used to compile the files in `src` into one minified `content.js` file, which goes in `../Resources/content.js`.

There is also a `src/test-dapp` folder. The files in this folder are not compiled but are instead used for testing the popover on a local development server.

You can also test the popover at https://safari-wallet-test-dapp.vercel.app. That dev server is synced with the `src/test-dapp` folder.

## Install

```sh
npm i
```

## Local Dev Server

1. Run the following command:

```sh
npx gulp
```

2. Navigate to http://localhost:3000/test-dapp/ in your browser.

## Build to `../Resources/content.js`

```sh
npx gulp build
```