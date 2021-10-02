`use strict`;

import gulp from 'gulp';
import dartSass from 'sass';
import gulpSass from 'gulp-sass';
import browserSync from 'browser-sync';
import cleanCSS from 'gulp-clean-css';
import rename from 'gulp-rename';
import cache from 'gulp-cache';
import autoprefixer from 'gulp-autoprefixer';
import notify from 'gulp-notify';
import fileinclude from 'gulp-file-include';
import htmlmin from 'gulp-htmlmin';

const sass = gulpSass(dartSass);

function minifyHtml(cb) {
    gulp.src(`src/html/**/*.html`).pipe(htmlmin({ collapseWhitespace: true, removeComments: true, })).pipe(gulp.dest(`src/build/html`));
    setTimeout(() => cb(), 100);
}

function moveFonts(cb) {
    gulp.src(`src/fonts/*`).pipe(gulp.dest(`src/build/fonts`));
    cb();
}

function commonJs(cb) {
    gulp.src([`src/js/**/*.js`]).pipe(fileinclude({ basepath: `@file`, prefix: `@@`, })).pipe(rename({ prefix : ``, suffix: `.min`, })).pipe(gulp.dest(`src/build/js`)).pipe(browserSync.stream());
    cb();
}

function browser(cb) {
    browserSync({ notify: false, open: false, server: { baseDir: `src`, }, });
    cb();
}

function code(cb) {
    gulp.src(`src/test-dapp/*.html`).pipe(browserSync.stream());
    cb();
}

function scss(cb) {
    gulp.src(`src/scss/**/*.scss`).pipe(sass.sync().on(`error`, sass.logError)).pipe(rename({ prefix : ``, suffix: `.min`, })).pipe(autoprefixer([`last 2 versions`]))
    .pipe(cleanCSS())
    .pipe(gulp.dest(`src/build/css`))
    setTimeout(() => cb(), 100);
}

function files(cb) {
    setTimeout(() => {
        gulp.src([`src/build/js/app.min.js`]).pipe(rename(`content.js`)).pipe(gulp.dest(`../Resources`));
        gulp.src([`src/fonts/*`]).pipe(gulp.dest(`../Resources`));
        cb();
    }, 500);
}
function clearCache (cb) { 
    cache.clearAll();
    cb(); 
}

function watch(cb) {
    gulp.watch(`src/scss/**/*.scss`, gulp.series(scss, commonJs));
    gulp.watch(`src/html/**/*.html`, gulp.series(minifyHtml, commonJs));
    gulp.watch(`src/js/**/*.js`, gulp.parallel(commonJs));
    gulp.watch(`src/test-dapp/*.html`, gulp.parallel(code));
    gulp.watch(`src/fonts/*`, gulp.parallel(moveFonts));
    cb();
}

exports.build = gulp.series(minifyHtml, scss, commonJs, files);

exports.clearcache = gulp.parallel(clearCache);

exports.buildhtml = gulp.parallel(minifyHtml);
exports.buildcss = gulp.parallel(scss);
exports.buildjs = gulp.parallel(commonJs);
exports.buildfiles = gulp.parallel(files);
exports.buildfonts = gulp.parallel(moveFonts);

exports.default = gulp.parallel(watch, browser);