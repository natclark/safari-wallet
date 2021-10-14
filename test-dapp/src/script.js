`use strict`;

// For older browsers:
typeof window.addEventListener === `undefined` && (window.addEventListener = (e, cb) => window.attachEvent(`on${e}`, cb));

window.addEventListener(`load`, () => {

    const $ = (id) => document.getElementById(id);

    let currentAccounts = [];

    $(`connect`).addEventListener(`click`, async () => {
        if (typeof window.ethereum !== `undefined`) {
            try {
                currentAccounts = await window.ethereum.request({ method: `eth_requestAccounts`, });
                $(`wallet`).innerText = currentAccounts[0];
            } catch (e) {
                alert(`Something went wrong with eth_requestAccounts.`);
                $(`wallet`).innerText = `Not Connected.`;
            }
        } else {
            alert(`window.ethereum is undefined. Is the wallet extension installed and active?`);
            $(`wallet`).innerText = `Not Connected.`;
        }
    });

    $(`sign`).addEventListener(`click`, async () => {
        if (currentAccounts.length > 0) {
            try {
                const EIP712Domain = [
                    { name: `name`, type: `string`, },
                    { name: `version`, type: `string`, },
                    { name: `chainId`, type: `uint256`, },
                    { name: `verifyingContract`, type: `address`, },
                    { name: `salt`, type: `bytes32`, },
                ];
                const Echo = [
                    { name: `message`, type: `string`, },
                    { name: `bidder`, type: `Identity`, },
                ];
                const Identity = [
                    { name: `userId`, type: `uint256`, },
                    { name: `wallet`, type: `address`, }
                ];
                const domain = {
                    name: `Safari Wallet Test dApp`,
                    version: `2`,
                    chainId: 1,
                    verifyingContract: ``, // TODO
                    salt: ``, // TODO
                };
                const message = {
                    amount: `Hello World`,
                    bidder: {
                        userId: 1337,
                        wallet: currentAccounts[0],
                    }
                };
                const data = JSON.stringify({
                    types: {
                        EIP712Domain,
                        Echo,
                        Identity,
                    },
                    domain,
                    primaryType: `Echo`,
                    message,
                });
                await window.ethereum.request({
                    method: `eth_signTypedData_v3`,
                    params: [currentAccounts[0], data],
                    from: currentAccounts[0],
                });
            } catch (e) {
                alert(`Something went wrong with eth_sign.`);
            }
        } else {
            alert(`Please connect a wallet first.`);
        }
    });

});