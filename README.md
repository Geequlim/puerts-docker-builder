## Puerts 库构建容器

目前仅支持构建 Unity 的 Android 库

## 使用方式
0. 获取 puerts 的源码
1. 构建 Docker 镜像
```bash
docker build . puerts:unity-android
```
2. 修改 `unity/native_src/CMakeLists.txt` 调整构建配置
3. 通过 Docker 进行构建
```bash
# 需要将你的 puerts 源码目录挂载到 /root/puerts
docker run --rm -v /mnt/d/dev/puerts:/root/puerts puerts:unity-android
```

### 可选环境变量参数
- `-e ENGINE=v8` 要构建的JS引擎类型，目前仅支持`v8`
- `-e CMAKE_OPTIONS=""` 要传递给`cmake`的配置参数
