/* GULP DEPENDENCIES */
var gulp    = require('gulp');
var del     = require('del');
var coffee  = require('gulp-coffee');
var uglify  = require('gulp-uglify');
var cssmin  = require('gulp-minify-css');
var htmlmin = require('gulp-minify-html');
var util    = require('gulp-util');
var inject  = require('gulp-inject');
var maps    = require('gulp-sourcemaps');
var rename  = require('gulp-rename');
// var open    = require('gulp-open');
var path    = require("path");
var less    = require("gulp-less");

gulp.task('img', function(){
    return gulp.src('./public/src/img/*')
        .pipe(gulp.dest('./public/dist/img'))
});

gulp.task('clean-css', function (cb) {
    del(["./public/dist/**/*.css"], cb);
});
gulp.task("less", ["clean-css"], function() {
    return gulp.src("./public/src/**/*.less")
        .pipe(less({ paths: [ path.join(__dirname, 'public/src') ] }))
        .pipe(cssmin())
        .pipe(rename({ extname: ".min.css" }))
        .pipe(gulp.dest("./public/dist/"));
});
gulp.task("css", ["clean-css"], function(){
    return gulp.src("./public/src/**/*.css")
        .pipe(cssmin())
        .pipe(rename({ extname: ".min.css" }))
        .pipe(gulp.dest("./public/dist/"))
});

gulp.task('clean-js', function (cb) {
    del(['./public/dist/**/*.js'], cb);
});
gulp.task('coffee', ['clean-js'], function() {
    return gulp.src('./public/src/**/*.coffee')
        .pipe(maps.init())
        .pipe(coffee({bare: true}).on('error', util.log))
        .pipe(uglify({mangle:false}))
        .pipe(rename({
            extname: '.min.js'
        }).on('error', util.log))
        .pipe(maps.write())
        .pipe(gulp.dest('./public/dist/'))
});

gulp.task('clean-html', function(cb) {
    del(['public/dist/**/*.html'], cb);
});
gulp.task('move-html', ['clean-html'], function(){
    return gulp.src('public/src/**/*.html')
        .pipe(gulp.dest('./public/dist/'))
});
gulp.task('build', ['move-html', 'img', 'css', 'less', 'coffee'], function(){
    var importantSources = gulp.src(['./public/dist/app.min.js'], {read: false});
    var sources = gulp.src([
      '!./public/dist/app.min.js',
      './public/dist/**/*.js',
      './public/dist/**/*.css'
    ], {read: false});
    gulp.src('./public/dist/**/*.html')
        .pipe(inject(
            importantSources,
            {relative: true},
            {starttag: '<!-- inject:head:{{ext}} -->'}
        ))
        .pipe(inject(sources, {relative: true}))
        .pipe(htmlmin({
            empty: true,
            cdata: false,
            comments: false,
            conditionals: false,
            spare: false,
            quotes: false,
            loose: true
        }))
        .pipe(gulp.dest('./public/dist/'))
});
gulp.task('default', ['build'], function(){});
