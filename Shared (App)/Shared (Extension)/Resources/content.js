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
browser.runtime.onMessage.addListener((request) => {
    window.postMessage(request.message);
});
