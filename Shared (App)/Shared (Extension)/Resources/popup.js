`use strict`;

const $ = (query) =>
    query[0] === (`#`)
    ? document.querySelector(query)
    : document.querySelectorAll(query);

const closeWindow = () =>
    window.close();

const updatePopup = (tabs) => {
    const tab = tabs[0];
    $(`#title`).textContent = tab.title;
    $(`#host`).textContent = new URL(tab.url).host;
    $(`#address`).textContent = `0x`; // TODO
    $(`#balance`).textContent = `0 ETH`; // TODO
}

const connectWallet = () => {
    browser.runtime.sendMessage({
        message: `eth_requestAccounts`,
    });
    window.close();
};

document.addEventListener(`DOMContentLoaded`, () => {
    $(`#cancel`).addEventListener(`click`, closeWindow);
    $(`#connect`).addEventListener(`click`, connectWallet);
    browser.tabs.query({
        active: true,
        currentWindow: true,
    }, updatePopup);
});

// * This forwards messages from background.js to content.js
browser.runtime.onMessage.addListener((request) => {
    browser.tabs.query({
        active: true,
        currentWindow: true,
    }, (tabs) => {
        browser.tabs.sendMessage(tabs[0].id, { message: request.message.message, });
    });
});
