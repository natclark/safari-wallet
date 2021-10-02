`use strict`;

function SafariWallet() {
	this.opened = false;

	var html = `<div class="popup"><h1>Connect to Mirror</h1><p class="subtitle">mirror.xyz</p><p>When you connect your wallet, this dapp will be able to view the contents:</p><div class="field"><label class="field__label" for="address">Address</label> <input id="address" class="field__input" type="text" value="0x255E9B54F41F44F42150b6aAA730Da5f2d23Faf2" disabled="disabled"></div><div class="field"><label class="field__label" for="balance">ETH Balance</label> <input id="balance" class="field__input" type="text" value="12.142 ETH" disabled="disabled"></div><div class="field"><label class="field__label" for="ens">ENS records</label> <input id="ens" class="field__input" type="text" value="ric.eth" disabled="disabled"></div><div class="flex"><button class="button button--secondary">Cancel</button> <button class="button button--primary">Connect</button></div></div>`;
	this.popup = document.createElement(`div`);
	this.popup.innerHTML = html;
}

SafariWallet.prototype.open = () => {
	if (window.safariWallet.opened === false) {
		window.safariWallet.opened = true;
		document.body.insertBefore(window.safariWallet.popup, document.body.firstChild);
	}
};

SafariWallet.prototype.close = () => {
	if (!!window.safariWallet.opened) {
		document.body.removeChild(window.safariWallet.popup);
	}
};

// For older browsers:
typeof window.addEventListener === `undefined` && (window.addEventListener = (e, cb) => window.attachEvent(`on${e}`, cb));

window.addEventListener(`load`, () => {

	if (typeof window.safariWallet === `undefined`) {
		window.safariWallet = new SafariWallet();
	}

});