`use strict`;

try {

    let chain = 1;
    let address = `0x`;
    let balance = 0;

    let method = ``;

    const chains = {
        1: {
            gasToken: `ETH`,
        },
    };

    const views = {
        default: () => `
            <h1>Safari Wallet</h1>
        `,
        connectWallet: () => `
            <h1>Connect to <span id="title"></span></h1>
            <p class="subtitle"><span id="host"></span></p>
            <p>When you connect your wallet, this dapp will be able to view the contents:</p>
            <div class="field">
                <label class="field__label" for="address">Address</label>
                <input id="address" class="field__input" type="text" value="${address}" disabled>
            </div>
            <div class="field">
                <label class="field__label" for="balance">ETH Balance</label>
                <input id="balance" class="field__input" type="text" value="${balance} ${chains[chain].gasToken}" disabled>
            </div>
            <div class="flex">
                <button id="cancel" class="button button--secondary">Cancel</button>
                <button id="connect" class="button button--primary">Connect</button>
            </div>
        `,
        signMessage: () => `
            <h1>Sign Message</h1>
            <div class="flex">
                <button id="cancel" class="button button--secondary">Cancel</button>
                <button id="sign" class="button button--primary">Sign</button>
            </div>
        `,
    };

    const $ = (query) =>
        query[0] === (`#`)
        ? document.querySelector(query)
        : document.querySelectorAll(query);

    const closeWindow = () =>
        window.close();

    const connectWallet = () => {
        browser.runtime.sendMessage({
            message: {
                message: `eth_requestAccounts`,
            },
        });
        closeWindow();
    };

    const signMessage = () => {
        /*
        browser.runtime.sendMessage({
            message: {
                from: ``,
                message: `eth_signTypedData_v3`,
                params: {},
            },
        });
        */
        closeWindow();
    };

    const refreshView = () => {
        switch (method) {
            case `eth_requestAccounts`:
                $(`#body`).innerHTML = views.connectWallet();
                $(`#cancel`).addEventListener(`click`, closeWindow);
                $(`#connect`).addEventListener(`click`, connectWallet);
                browser.tabs.query({
                    active: true,
                    currentWindow: true,
                }, (tabs) => {
                    const tab = tabs[0];
                    $(`#title`).textContent = tab.title;
                    $(`#host`).textContent = new URL(tab.url).host;
                });
                break;
            case `eth_signTypedData_v3`:
                $(`#body`).innerHTML = views.signMessage();
                $(`#cancel`).addEventListener(`click`, closeWindow);
                $(`#sign`).addEventListener(`click`, signMessage);
                break;
            default:
                $(`#body`).innerHTML = views.default();
        }
    };

    document.addEventListener(`DOMContentLoaded`, () => {
        browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
            browser.tabs.query({
                active: true,
                currentWindow: true,
            }, (tabs) => {
                // * This updates the default address
                if (typeof request.message.address !== `undefined`) {
                    address = request.message.address;
                }
                // * This updates the gas token balance of the default address on the selected network
                if (typeof request.message.balance !== `undefined`) {
                    balance = request.message.balance;
                }
                // * This updates the view based on the current method
                if (typeof request.message.method !== `undefined`) {
                    method = request.message.method;
                    refreshView();
                }
                // * This forwards messages from background.js to content.js
                if (typeof request.message.message !== `undefined`) {
                    browser.tabs.sendMessage(tabs[0].id, {
                        message: request.message.message,
                    });
                }
            });
        });
        browser.runtime.sendMessage({
            message: {
                message: `get_state`,
            },
        });
    });

} catch (e) {
    console.log(`popup.js [error]:`, e.message);
}
