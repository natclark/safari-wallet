`use strict`;

function inject(content) {
  try {
    const body = document.body;
    const injection = document.createElement(`script`);
    injection.setAttribute(`type`, `text/javascript`);
    injection.setAttribute(`async`, `false`);
    injection.textContent = content;
    body.insertBefore(injection, body.firstChild);
  } catch (error) {
    console.error(`safari-wallet: script injection failed:`, error);
  }
}
