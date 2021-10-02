`use strict`;

function SafariWallet () {
	this.opened = false;

	const html = `@@include('../build/html/popover.html')`;
	this.popover = document.createElement(`div`);
	this.popover.innerHTML = html;

	const css = `@@include('../build/css/style.min.css')`;
	this.style = document.createElement(`style`);
	this.style.setAttribute(`type`, `text/css`);
	this.style.innerHTML = css;
	document.body.appendChild(this.style);
}

SafariWallet.prototype.open = () => {
	if (window.safariWallet.opened === false) {
		window.safariWallet.opened = true;
		document.body.insertBefore(window.safariWallet.popover, document.body.firstChild);
	}
};

SafariWallet.prototype.close = () => {
	if (!!window.safariWallet.opened) {
		document.body.removeChild(window.safariWallet.popover);
		window.safariWallet.opened = false;
	}
};

// For older browsers:
typeof window.addEventListener === `undefined` && (window.addEventListener = (e, cb) => window.attachEvent(`on${e}`, cb));

window.addEventListener(`load`, () => {

	if (typeof window.safariWallet === `undefined`) {
		window.safariWallet = new SafariWallet();
	}

});