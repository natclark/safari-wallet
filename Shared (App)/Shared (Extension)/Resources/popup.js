`use strict`;

const $ = (query) =>
    query[0] === (`#`)
    ? document.querySelector(query)
    : document.querySelectorAll(query);

function closeWindow() {
	window.close();
}

function updatePopup(tabs) {
	let tab = tabs[0];
	$(`#title`).textContent = tab.title;
	$(`#host`).textContent = new URL(tab.url).host;
}

function connectWallet() {
    browser.runtime.sendMessage({
        message: `eth_requestAccounts`,
    });
//    window.close();
}

/*
function getCurrentAddress() {
    browser.runtime.sendMessage({
        message: `GET_CURRENT_ADDRESS`,
    });
}

function getCurrentHDWallet() {
    browser.runtime.sendMessage({message: `GET_CURRENT_HDWALLET`});
}

function openContainingApp() {
//    browser.runtime.sendMessage({message: "OPEN_CONTAINING_APP"}); // todo: add path parameter
//    window.open("https://www.apple.com","_self"); ??
}

function signRawTx() {
    browser.runtime.sendMessage({message: `SIGN_RAW_TX`}); // todo: add tx as parameter
}
*/

document.addEventListener(`DOMContentLoaded`, () => {
	$(`#cancel`).addEventListener(`click`, closeWindow);
    $(`#connect`).addEventListener(`click`, connectWallet);
    //$(`#getCurrentAddress`).addEventListener(`click`, getCurrentAddress);
    //$(`#getCurrentHDWallet`).addEventListener(`click`, getCurrentHDWallet);
    //$(`#openWallet`).addEventListener(`click`, openContainingApp);
    //$(`#signRawTx`).addEventListener(`click`, signRawTx);
	browser.tabs.query({ currentWindow: true }, updatePopup);
});

browser.runtime.onMessage.addListener((request) => {
    console.log(`safari-wallet.popup request received: ${request}`);
    if (request.type === `Word count response`) {
        let countDiv = document.getElementById(`messageResponse`);

        if (!countDiv.hasChildNodes())
            countDiv.appendChild(document.createTextNode(`Response: ${request.return-value}`));
    }
});
