`use strict`;

const $ = (query) =>
    query[0] === (`#`)
    ? document.querySelector(query)
    : document.querySelectorAll(query);

function closeWindow() {
	window.close();
}

function updatePopup(tabs) {
	const tab = tabs[0];
	$(`#title`).textContent = tab.title;
	$(`#host`).textContent = new URL(tab.url).host;
}

function connectWallet() {
    browser.runtime.sendMessage({
        message: `eth_requestAccounts`,
    });
    window.close();
}

/*
function openContainingApp() {
//    browser.runtime.sendMessage({message: "OPEN_CONTAINING_APP"}); // todo: add path parameter
//    window.open("https://www.apple.com","_self"); ??
}
*/

document.addEventListener(`DOMContentLoaded`, () => {
	$(`#cancel`).addEventListener(`click`, closeWindow);
    $(`#connect`).addEventListener(`click`, connectWallet);
	browser.tabs.query({ currentWindow: true, }, updatePopup);
});

// * This forwards messages from background.js to content.js
browser.runtime.onMessage.addListener((request) => {
    browser.tabs.query({ active: true, currentWindow: true, }, (tabs) => {
        browser.tabs.sendMessage(tabs[0].id, { message: request.message, });
    });
});
