`use strict`;

const injection = document.createElement(`script`);
injection.setAttribute(`type`, `text/javascript`);
injection.innerHTML = `

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

function Ethereum() {
    this.opened = false;
    this.overlay = document.createElement('div');
    this.overlay.style.backgroundColor = '#000';
    this.overlay.style.height = '100vh';
    this.overlay.style.left = 0;
    this.overlay.style.opacity = 0;
    this.overlay.style.position = 'fixed';
    this.overlay.style.top = 0;
    this.overlay.style.transition = 'opacity .2s';
    this.overlay.style.width = '100vw';
    this.overlay.style.willChange = 'opacity';
    this.overlay.style.zIndex = 9999999;
    this.close = () => {
        this.overlay.style.opacity = 0;
        this.div.style.transform = 'translateY(100%)';
        this.overlay.remove();
        this.div.remove();
        this.opened = false;
    };
    this.overlay.onclick = () => this.close();
    this.div = document.createElement('div');
    this.div.style.alignItems = 'center';
    this.div.style.backgroundColor = '#fff';
    this.div.style.borderRadius = '8px 8px 0 0';
    this.div.style.bottom = 0;
    this.div.style.columnGap = '18px';
    this.div.style.display = 'flex';
    this.div.style.fontSize = '18px';
    this.div.style.height = '45px';
    this.div.style.justifyContent = 'center';
    this.div.style.left = '30px';
    this.div.style.position = 'fixed';
    this.div.style.transform = 'translateY(100%)';
    this.div.style.transition = 'transform .3s';
    this.div.style.width = 'calc(100vw - 60px)';
    this.div.style.willChange = 'transform';
    this.div.style.zIndex = 10000000;
    this.div.innerHTML = \`
        <svg width="22px" height="16px" viewBox="0 0 22 16" fill="none">
            <path fill-rule="evenodd" clip-rule="evenodd" d="M0 1.33333C0 0.597005 0.616262 0 1.37634 0H15.1398C15.8998 0 16.5161 0.597005 16.5161 1.33333V6.23633C17.0205 5.68262 17.7583 5.33333 18.5806 5.33333C20.1008 5.33333 21.3333 6.52734 21.3333 8C21.3333 9.47266 20.1008 10.6667 18.5806 10.6667C17.7583 10.6667 17.0205 10.3174 16.5161 9.76367V14.6667C16.5161 15.403 15.8998 16 15.1398 16H1.37634C0.616262 16 0 15.403 0 14.6667V10.2445C0 9.33333 1.61089 9.26921 2.07089 9.77083C2.57526 10.3203 3.31048 10.6667 4.12903 10.6667C5.64919 10.6667 6.88171 9.47266 6.88171 8C6.88171 6.52734 5.64919 5.33333 4.12903 5.33333C3.31048 5.33333 2.57526 5.67969 2.07089 6.22917C1.61089 6.73079 0 6.66667 0 5.75553V1.33333Z" fill="#3478f6" />
        </svg>
        <p>Open the wallet extension to connect</p>
    \`;
}

Ethereum.prototype.request = () => {
    return new Promise((resolve, reject) => {
        if (window.ethereum.opened === false) {
            window.ethereum.opened = true;
            document.body.insertBefore(window.ethereum.overlay, document.body.firstChild);
            document.body.insertBefore(window.ethereum.div, document.body.firstChild);
            setTimeout(() => {
                window.ethereum.overlay.style.opacity = .4;
                window.ethereum.div.style.transform = 'translateY(0)';
            }, 1);
        }
        resolve(true);
    });
};

window.safariWallet = new SafariWallet();
window.ethereum = new Ethereum();

`;

document.body.insertBefore(injection, document.body.firstChild);
