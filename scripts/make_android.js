const cp = require("child_process");
const fs = require("fs");
const os = require('os');

const NDK = process.env.ANDROID_NDK;
if (!NDK) throw new Error('Please set ANDROID_NDK environment to the root of NDK.');

function build(API, ABI, TOOLCHAIN_ANME, ENGINE = "v8", CMAKE_OPTIONS = "") {
    console.log("开始构建", ENGINE, ABI, CMAKE_OPTIONS);
    const BUILD_PATH=`build.${ENGINE}.Android.${ABI}`;
    cp.execSync(`cmake -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON -DJS_ENGINE=${ENGINE} -DANDROID_ABI=${ABI} -H. -B${BUILD_PATH} -DCMAKE_TOOLCHAIN_FILE=${NDK}/build/cmake/android.toolchain.cmake -DANDROID_NATIVE_API_LEVEL=${API} -DANDROID_TOOLCHAIN=clang -DANDROID_TOOLCHAIN_NAME=${TOOLCHAIN_ANME} ${CMAKE_OPTIONS}`, { stdio: 'inherit'});
    cp.execSync(`cmake --build ${BUILD_PATH} --target clean`, { stdio: 'inherit'});
    cp.execSync(`cmake --build ${BUILD_PATH} --config Release -- -j${os.cpus().length}`, { stdio: 'inherit'});
    fs.mkdirSync(`../Assets/Plugins/Android/libs/${ABI}/`, { recursive: true });
    fs.copyFileSync(`${BUILD_PATH}/libpuerts.so`, `../Assets/Plugins/Android/libs/${ABI}/libpuerts.so`);
}

const ENGINE = process.argv[2] || 'v8';
const CMAKE_OPTIONS = process.argv[3] || '';
build('android-18', 'armeabi-v7a', 'arm-linux-androideabi-4.9', ENGINE, CMAKE_OPTIONS);
build('android-18', 'arm64-v8a', 'arm-linux-androideabi-clang', ENGINE, CMAKE_OPTIONS);
