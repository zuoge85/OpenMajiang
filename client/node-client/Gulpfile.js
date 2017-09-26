'use strict';


const del = require('del');
const fs = require('fs');
const gulp = require('gulp');
const uglify = require('gulp-uglify');
const sourcemaps = require('gulp-sourcemaps');
const plumber = require('gulp-plumber');
const connect = require('gulp-connect');
const rename = require("gulp-rename");
const imagemin = require('gulp-imagemin');
const minifyHTML = require('gulp-minify-html');
const minifyInline = require('gulp-minify-inline');
const htmlAutoprefixer = require("gulp-html-autoprefixer");
const replace = require('gulp-replace');
const gm = require("gm");
const converter = require('image-to-icon-converter');

let VERSION = gulp.env.version;
if (!VERSION) {
    VERSION = "v1";
}

let IS_DEBUG = !gulp.env.release;
let profile = gulp.env.profile;
if (!profile) {
    profile = "gd";
}

let IS_OPTIMIZE_IMG = !!gulp.env.optmize;

console.log("是否调试模式:", IS_DEBUG);
console.log("PROFILE:", profile);
console.log("OPTIMIZE:", IS_OPTIMIZE_IMG);
console.log("版本:", VERSION);

let SRC_PATH = "../laya-client/bin/h5";

let DIST_PATH = "dist/web";
let DIST_ROOT_PATH = "dist";


let paths = {
    layaJs: [SRC_PATH + '/myLaya.max.js'],
    images: [SRC_PATH + '/**/*.png', SRC_PATH + '/**/*.jpg'],
    json: SRC_PATH + '/res/**/*.json',
    index: 'web/index.html',
    cordovaIndex: 'web/cordovaIndex.html',
    icon: `web/icon/${profile}-icon.png`,
    splash: `web/splash.png`,
    splashLand: `web/splash-land.png`,
    htmlImage: 'web/**/*.png',
    audio: [SRC_PATH + '/**/*.mp3'],
    favicon: 'web/favicon.ico',
    docker: ['docker/Dockerfile']
};

function distPath(path) {
    if (path == null) {
        return DIST_PATH;
    }
    return DIST_PATH + path;
}


gulp.task('clean', function () {
    return del(['dist/*'], {force: true});
});


gulp.task('laya', function () {
    let pipe = gulp.src(paths.layaJs)
        .pipe(plumber())
        .pipe(sourcemaps.init());

    if (!IS_DEBUG) {
        pipe = pipe.pipe(uglify());
    }

    return pipe
        .pipe(rename(function (path) {
            path.basename = path.basename.replace(".max", ".min");
        }))
        .pipe(sourcemaps.write('.'))

        .pipe(gulp.dest(distPath()))
        .pipe(connect.reload());
});

gulp.task('images', function () {
    let pipe = gulp.src(paths.images)
        .pipe(plumber());

    if (IS_OPTIMIZE_IMG) {
        pipe = pipe
            .pipe(imagemin({
                verbose: true
            }));
    }

    return pipe
        .pipe(gulp.dest(distPath()));
});

gulp.task('json', function () {
    return gulp.src(paths.json)
        .pipe(plumber())
        .pipe(gulp.dest(distPath("/res")));
});

gulp.task('audio', function () {
    return gulp.src(paths.audio)
        .pipe(plumber())
        .pipe(gulp.dest(distPath()));
});

gulp.task('htmlImage', function () {
    return gulp.src(paths.htmlImage)
        .pipe(plumber())
        .pipe(gulp.dest(distPath()));
});

let htmlMinifyOption = {empty: true, comments: true};

let autoprefixerOption = {browsers: ['> 1%', 'IE 7'], cascade: false};
let minifyInlineOptions = {
    js: {
        output: {
            comments: true
        }
    }
};

gulp.task("index", function () {
    let result = gulp.src(paths.index)
        .pipe(plumber());

    result = result.pipe(replace('${version}', VERSION));
    result = result.pipe(htmlAutoprefixer(autoprefixerOption));

    if (!IS_DEBUG) {
        result = result.pipe(minifyHTML(htmlMinifyOption))
            .pipe(minifyInline(minifyInlineOptions))
    }
    result = result.pipe(gulp.dest(distPath()));
    return result.pipe(connect.reload());
});

gulp.task("cordovaIndex", function () {
    let result = gulp.src(paths.cordovaIndex)
        .pipe(plumber());


    result = result.pipe(rename(function (path) {
        path.basename = "index";
    }));

    result = result.pipe(replace('${version}', VERSION));
    result = result.pipe(htmlAutoprefixer(autoprefixerOption));

    if (!IS_DEBUG) {
        result = result.pipe(minifyHTML(htmlMinifyOption))
            .pipe(minifyInline(minifyInlineOptions))
    }
    result = result.pipe(gulp.dest(distPath()));
    return result.pipe(connect.reload());
});

gulp.task('icons', function (cb) {
    return new Promise(function (resolve, reject) {
        try {
            let iconSize = [57, 60, 72, 114, 144, 180];
            let count = iconSize.length + 1;
            let errors = [];
            let endFun = (error) => {
                if (error) {
                    errors.push(error);
                }
                if ((count--) == 0) {
                    if (error.length > 0) {
                        console.log(errors);
                        reject(new Error(errors));
                    } else {
                        resolve();
                    }
                }
            };

            let dirPath = distPath();
            if (!fs.existsSync(dirPath)) {
                fs.mkdirSync(dirPath);
            }

            dirPath = distPath(`/icon/`);
            if (!fs.existsSync(dirPath)) {
                fs.mkdirSync(dirPath);
            }
            iconSize.forEach((size) => {
                gm(paths.icon)
                    .resize(size, size)
                    .noProfile()
                    .gravity('Center')
                    .write(distPath(`/icon/${size}.png`), function (err) {
                        if (!err) {
                            endFun();
                        } else {
                            endFun(err);
                        }
                    });
            });


            gm(paths.icon)
                .resize(128, 128)
                .noProfile()
                .gravity('Center')
                .write(distPath(`/favicon.ico`), function (err) {
                    if (!err) {
                        endFun();
                    } else {
                        endFun(err);
                    }
                });
        } catch (error) {
            console.log(error);
            reject(error);
        }
    });
});

var iosIconInfo = [
    {w: 57, h: 57, name: "icon.png"},
    {w: 114, h: 114, name: "icon@2x.png"},
    {w: 40, h: 40, name: "icon-40.png"},
    {w: 80, h: 80, name: "icon-40@2x.png"},
    {w: 50, h: 50, name: "icon-50.png"},
    {w: 100, h: 100, name: "icon-50@2x.png"},
    {w: 60, h: 60, name: "icon-60.png"},
    {w: 120, h: 120, name: "icon-60@2x.png"},
    {w: 180, h: 180, name: "icon-60@3x.png"},
    {w: 72, h: 72, name: "icon-72.png"},
    {w: 114, h: 114, name: "icon-72@2x.png"},
    {w: 76, h: 76, name: "icon-76.png"},
    {w: 152, h: 152, name: "icon-76@2x.png"},
    {w: 29, h: 29, name: "icon-small.png"},
    {w: 58, h: 58, name: "icon-small@2x.png"},
    {w: 87, h: 87, name: "icon-small@3x.png"},
];

var androidIconInfo = [
    {w: 72, h: 72, name: "drawable-hdpi-icon.png"},
    {w: 36, h: 36, name: "drawable-ldpi-icon.png"},
    {w: 48, h: 48, name: "drawable-mdpi-icon.png"},
    {w: 96, h: 96, name: "drawable-xhdpi-icon.png"},
    {w: 144, h: 144, name: "drawable-xxhdpi-icon.png"},
    {w: 192, h: 192, name: "drawable-xxxhdpi-icon.png"},
];


gulp.task('androidIcons', icons(androidIconInfo, "android", "icon", paths.icon));
gulp.task('iosIcons', icons(iosIconInfo, "ios", "icon", paths.icon));


var androidSplashInfoLand = [
    // {w: 320, h: 200, name: "drawable-land-ldpi-screen.jpg"},
    // {w: 480, h: 320, name: "drawable-land-mdpi-screen.jpg"},
    // {w: 800, h: 480, name: "drawable-land-hdpi-screen.jpg"},
    // {w: 1280, h: 720, name: "drawable-land-xhdpi-screen.jpg"},
    // {w: 1600, h: 960, name: "drawable-land-xxhdpi-screen.jpg"},
    {w: 1920, h: 1280, name: "drawable-land-xxxhdpi-screen.jpg"},
];

var iosSplashInfoLand = [
    {h: 1242, w: 2208, name: "Default-Landscape-736h.jpg"},
    {h: 1536, w: 2048, name: "Default-Landscape@2x~ipad.jpg"},
    {h: 760, w: 1024, name: "Default-Landscape~ipad.jpg"},
];

var iosSplashInfo = [
    {h: 1136, w: 640, name: "Default-568h@2x~iphone.jpg"},
    {h: 1334, w: 750, name: "Default-667h.jpg"},
    {h: 2208, w: 1242, name: "Default-736h.jpg"},


    {h: 2048, w: 1536, name: "Default-Portrait@2x~ipad.jpg"},
    {h: 1024, w: 768, name: "Default-Portrait~ipad.jpg"},

    {h: 960, w: 640, name: "Default@2x~iphone.jpg"},
    {h: 480, w: 320, name: "Default~iphone.jpg"},
];

gulp.task('androidSplash', icons(androidSplashInfoLand, "android", "splash", paths.splashLand));
gulp.task('iosSplashLand', icons(iosSplashInfoLand, "ios", "splash", paths.splashLand));
// gulp.task('iosSplash', icons(iosSplashInfo, "ios","splash", paths.splash));

function icons(iconInfos, type, dirType, source) {
    return function icons(cb) {
        return new Promise(function (resolve, reject) {
            try {
                let count = iconInfos.length + 1;
                let errors = [];
                let endFun = (error) => {
                    if (error) {
                        errors.push(error);
                    }
                    if ((count--) == 0) {
                        console.log("结束");
                        if (error.length > 0) {
                            console.log(errors);
                            reject(new Error(errors));
                        } else {
                            resolve();
                        }
                    }
                };

                let dirPath = distPath();
                if (!fs.existsSync(dirPath)) {
                    fs.mkdirSync(dirPath);
                }

                dirPath = distPath(`/icon/`);
                if (!fs.existsSync(dirPath)) {
                    fs.mkdirSync(dirPath);
                }
                iconInfos.forEach((item) => {
                    gm(source)
                        .resize(item.w, item.h)
                        .noProfile()
                        .gravity('Center')
                        .write((`../cordova/resources/${type}/${dirType}/${item.name}`), function (err) {
                            if (!err) {
                                endFun();
                            } else {
                                endFun(err);
                            }
                        });
                    ;
                });
            } catch (error) {
                console.log(error);
                reject(error);
            }
        });
    }
}

gulp.task('favicon', function () {
    return gulp.src(paths.favicon)
        .pipe(plumber())
        .pipe(gulp.dest(distPath()));
});

gulp.task('docker', function () {
    return gulp.src(paths.docker)
        .pipe(plumber())
        .pipe(gulp.dest(DIST_ROOT_PATH));
});

gulp.task('dist', ['laya', 'images', 'json', 'index', 'icons', 'favicon', 'docker', 'audio']);
gulp.task('default', ['watch', 'connect']);


gulp.task('cordovaClean', function () {
    return del(['../cordova/www/*'], {force: true});
});


gulp.task('cordovaIcon', function () {
    return gulp.src(['dist/web/icon/180.png'])
        .pipe(plumber())
        .pipe(gulp.dest("../cordova/icon"));
});

// 标注一个依赖，依赖的任务必须在这个任务开始之前被完成
gulp.task('cordova', ['cordovaIcon', 'cordovaClean', 'laya', 'images', 'json', 'cordovaIndex', 'favicon', 'docker', 'audio'], function () {
    // 现在任务 'one' 已经完成了
    console.log("cordova start");

    return gulp.src(['dist/web/**/*'])
        .pipe(plumber())
        .pipe(gulp.dest("../cordova/www"));
});

gulp.task('webclient', ['htmlImage', 'laya', 'images', 'json', 'favicon', 'docker', 'audio'], function () {
    // 现在任务 'one' 已经完成了
    console.log("webclient start");
    return gulp.src(['dist/web/**/*'])
        .pipe(plumber())
        .pipe(gulp.dest("../../server/project/distribution/src/static/" + profile))
        .pipe(gulp.dest("../../server/project/mj-client/src/main/resources/static/" ));
});