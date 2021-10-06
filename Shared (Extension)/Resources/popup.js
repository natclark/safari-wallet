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


document.addEventListener("DOMContentLoaded", function() {
	document.getElementById("cancel").addEventListener("click", closeWindow)
    document.getElementById("connect").addEventListener("click", connectWallet) // temp to test messaging
	browser.tabs.query({ currentWindow: true }, updatePopup)
})
