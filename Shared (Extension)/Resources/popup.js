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

document.addEventListener("DOMContentLoaded", function() {
	document.getElementById("cancel").addEventListener("click", closeWindow)
	browser.tabs.query({ currentWindow: true }, updatePopup)
})
