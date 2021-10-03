`use strict`;

console.log(`Hello World!`, browser);

const $ = (id) => document.getElementById(id);

$(`cancel`).addEventListener(`click`, () => {
	window.close();
});

$(`connect`).addEventListener(`click`, () => {
	// TODO
});
