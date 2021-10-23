`use strict`;

const inject = (path) => {
    const injection = document.createElement(`script`);
    injection.setAttribute(`type`, `text/javascript`);
    injection.setAttribute(`async`, `false`);
    injection.setAttribute(`src`, browser.runtime.getURL(path));
    document.body.insertBefore(injection, document.body.firstChild);
};

inject(`ethereum/dist.js`);

// * This forwards messages from popup.js to ethereum/index.js
browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    window.postMessage(request.message);
});

// * This forwards messages from ethereum/index.js to background.js
window.addEventListener(`message`, (event) => {
    browser.runtime.sendMessage({
        message: {
            message: `update_method`,
            method: event.data,
        },
    });
});
