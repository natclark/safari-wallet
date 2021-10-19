`use strict`;

browser.runtime.onMessage.addListener(async (request, sender, sendResponse) => {
    if (typeof request.message === `undefined`) return;

    switch (request.message) {
        case `eth_requestAccounts`:
            const address = await browser.runtime.sendNativeMessage({
                message: `GET_CURRENT_ADDRESS`,
            });
            browser.runtime.sendMessage({ message: address, });
            break;
        case `cancel`:
            browser.runtime.sendMessage({ message: `cancel`, });
        default:
            console.log(`unimplemented`, request.message);
    }
});
