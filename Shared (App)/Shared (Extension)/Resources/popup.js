`use strict`;

console.log(`Hello World!`, browser);

function closeWindow() {
	window.close()
}

function updatePopup(tabs) {
	let tab = tabs[0]
	document.getElementById("title").textContent = tab.title
	document.getElementById("host").textContent = new URL(tab.url).host
}

function connectWallet()
{
    console.log("safari-wallet.popup: connect button clicked");
    browser.runtime.sendMessage({message: "Connect wallet"})
    window.close();
}

function getCurrentAddress()
{
    browser.runtime.sendMessage({message: "GET_CURRENT_ADDRESS"})
}

function getCurrentHDWallet()
{
    browser.runtime.sendMessage({message: "GET_CURRENT_HDWALLET"})
}

document.addEventListener("DOMContentLoaded", function() {
	document.getElementById("cancel").addEventListener("click", closeWindow)
    document.getElementById("connect").addEventListener("click", connectWallet)
    document.getElementById("getCurrentAddress").addEventListener("click", getCurrentAddress)
    document.getElementById("getCurrentHDWallet").addEventListener("click", getCurrentHDWallet)
	browser.tabs.query({ currentWindow: true }, updatePopup)
})

browser.runtime.onMessage.addListener((request) => {
    console.log("safari-wallet.popup request received: ${request}");
    if (request.type == "Word count response") {
        let countDiv = document.getElementById("messageResponse");

        if (!countDiv.hasChildNodes())
            countDiv.appendChild(document.createTextNode(`Response: ${request.return-value}`));
    }
});
