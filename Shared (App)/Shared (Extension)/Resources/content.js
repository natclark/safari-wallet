`use strict`;

const inject = (path) => {
    const injection = document.createElement(`script`);
    injection.setAttribute(`type`, `text/javascript`);
    injection.setAttribute(`async`, `false`);
    injection.setAttribute(`src`, browser.runtime.getURL(path));
    document.body.insertBefore(injection, document.body.firstChild);
};

inject('injections/ethereum.js');

window.addEventListener(`message`, (event) => {
    //browser.runtime.sendMessage({ message: event.data, });
});
