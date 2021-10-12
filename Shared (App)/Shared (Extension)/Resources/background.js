`use strict`;

var port = browser.runtime.connectNative("application.id");
port.onMessage.addListener((response) => {
  console.log("background connectNative received: " + response);
});

browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    console.log(`Received request: `, request);

    if (request.greeting === `hello`)
        sendResponse({ farewell: `goodbye`, });
    if (request.message == "Connect wallet") {
        browser.runtime.sendNativeMessage({ message: "Connect wallet" })
    }
    if (request.message == "GET_CURRENT_ADDRESS") {
        browser.runtime.sendNativeMessage({ message: "GET_CURRENT_ADDRESS" })
    }
    if (request.message == "GET_CURRENT_HDWALLET") {
        browser.runtime.sendNativeMessage({ message: "GET_CURRENT_ADDRESS" })
    }
    // can we just pass any message we receive?
});



