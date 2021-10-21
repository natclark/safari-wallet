`use strict`;

let method = ``;

browser.runtime.onMessage.addListener(async (request, sender, sendResponse) => {
    if (typeof request.message === `undefined`) return;

    try {
        switch (request.message.message) {
            case `eth_requestAccounts`: // * Return requested data from native app to popup.js
                const address = await browser.runtime.sendNativeMessage({
                    message: `GET_CURRENT_ADDRESS`,
                });
                browser.runtime.sendMessage({
                    message: address,
                });
                break;
            case `cancel`: // * Cancel current method and notify popup.js of cancellation
                browser.runtime.sendMessage({
                    message: {
                        message: `cancel`,
                    },
                });
                break;
            case `get_address`: // * Send current method to popup.js
                /*
                TODO
                const address = await browser.runtime.sendNativeMessage({
                    message: `GET_CURRENT_ADDRESS`,
                });
                browser.runtime.sendMessage({
                    message: {
                        address: address.message,
                    },
                });
                */
                break;
            case `get_balance`:
                /*
                TODO
                const balance = await browser.runtime.sendNativeMessage({
                    message: `GET_CURRENT_BALANCE`,
                });
                browser.runtime.sendMessage({
                    message: {
                        message: balance.message,
                    },
                });
                */
                break;
            case `get_method`:
                browser.runtime.sendMessage({
                    message: {
                        method,
                    },
                });
                break;
            case `update_method`: // * Update current method from content.js
                method = request.message.method === `cancel`
                    ? ``
                    : request.message.method;
                break;
            default: // * Unimplemented or invalid method
                console.log(`background [unimplemented]:`, request.message.message);
        }
    } catch (e) {
        console.log(`background [error]:`, e.message);
    }
});
