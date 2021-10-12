content = `
function SafariWallet() {
    this.opened = false;
}

SafariWallet.prototype.open = () => {
    if (window.safariWallet.opened === false) {
        window.safariWallet.opened = true;
        try {
            alert('Apple does not yet allow us to open the popover programmatically.');
        } catch (e) {
            alert('Error: ', e.message);
        }
    }
};

SafariWallet.prototype.close = () => {
    if (!!window.safariWallet.opened) {
        window.safariWallet.opened = false;
    }
};

window.safariWallet = new SafariWallet();
if (typeof window.safariWallet != 'undefined') console.info('window.safariWallet is injected.')
`

inject(content)
