`use strict`;

browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    console.log(`Received request: `, request);

    if (request.greeting === `hello`)
        sendResponse({ farewell: `goodbye`, });
    if (request.message == "Connect wallet") {
        browser.runtime.sendNativeMessage({ message: "Connect wallet" })
    }
        
});
