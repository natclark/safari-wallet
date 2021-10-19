`use strict`;

const inject = (path) => {
    const injection = document.createElement(`script`);
    injection.setAttribute(`type`, `text/javascript`);
    injection.setAttribute(`async`, `false`);
    injection.setAttribute(`src`, browser.runtime.getURL(path));
    document.body.insertBefore(injection, document.body.firstChild);
};

inject(`injections/dist.js`);

// * This forwards messages from popup.js to injections/ethereum.js
browser.runtime.onMessage.addListener((request) => {
    window.postMessage(request.message);
});
