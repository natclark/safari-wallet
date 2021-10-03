`use strict`;

const gulp = require(`gulp`);
const browserSync = require(`browser-sync`);
const cache = require(`gulp-cache`);

function browser(cb) {
    browserSync({ notify: false, open: false, server: { baseDir: `src`, }, });
    cb();
}

function code(cb) {
    gulp.src(`src/*.html`).pipe(browserSync.stream());
    cb();
}

function clearCache (cb) { 
    cache.clearAll();
    cb(); 
}

function watch(cb) {
    gulp.watch(`src/*.html`, gulp.parallel(code));
    cb();
}

exports.clearcache = gulp.parallel(clearCache);

exports.default = gulp.parallel(watch, browser);