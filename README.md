# 构建ijkplayer私有pod

##### 1. 准备资源

1. 下载ijkplayer

```shell
git clone https://github.com/bilibili/ijkplayer
```

2. 执行脚本下载ffmpeg

```
./init-ios.sh
```

3. 进入ios目录，对脚本进行处理 compile-ffmpeg.sh  compile-openssl.sh

 ```js
./compile-ffmpeg.sh clean
./compile-ffmpeg.sh all
 ```

##### 2. 支持https

```js
// 初始化
./init-ios-openssl.sh
// 进入ios目录添加配置
echo 'export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-openssl"' >> ../config/module.sh
// clean
./compile-ffmpeg.sh clean
// 开始编译
./compile-openssl.sh all
// 编译ffmpeg
./compile-ffmpeg.sh all
```

* 以上完成之后，IJKMediaDemo便可播放ssl的连接了。

##### 3. 制作framework

1. 打开target->IJKMediaFramework->build

2. 在Products->Release-iphoneos->IJKMediaFramework.framework

   ```js
   // 查看支持的指令
   lipo -info IJKMediaFramework.framework/IJKMediaFramework
   'Architectures in the fat file: IJKMediaFramework.framework/IJKMediaFramework are: arm64 armv7'
   ```

3. 用模拟器在build一遍，将两个framework拷贝出来再合并。

   ```shell
   lipo -create IJKMediaFramework.framework/IJKMediaFramework sim/IJKMediaFramework.framework/IJKMediaFramework -output out/IJKMediaFramework
   ```

4. 这里会出现合并失败的错误，原因是xcode12的模拟器也包含了arm64指令，删除其中的一个即可。

   ```js
   lipo -remove IJKMediaFramework -o IJKMediaFramework
   ```

5. 合并后可以看到更多的支持指令

   ```js
   lipo -info IJKMediaFramework
   // Architectures in the fat file: IJKMediaFramework are: armv7 i386 x86_64 arm64
   ```

##### 4. 构建私有库

   1. 完成以上步骤后，我们将得到一个可运行的IJKMediaFramework.framework

   2. 接下来构建私有的pod

      ```ruby
      pod lib create BWPlayer
      ```

        3. 在BWPlayer.podspec中

       ```js
       Pod::Spec.new do |s|
         s.name             = 'BWPlayer'
         s.version          = '0.1.0'
         s.summary          = 'A short description of BWPlayer.'
         s.description      = <<-DESC
       TODO: Add long description of the pod here.
                              DESC
       
         s.homepage         = 'https://github.com/bairdweng/BWPlayer'
         s.license          = { :type => 'MIT', :file => 'LICENSE' }
         s.author           = { 'bairdweng' => 'bairdweng@gmail.com' }
         s.source           = { :git => 'https://github.com/bairdweng/BWPlayer.git', :tag => s.version.to_s}
         s.requires_arc  = true
         s.ios.deployment_target = '9.0'
         s.swift_version = "4.2"
         // 已经构建好的IJKMediaFramework.framework存放目录
         s.vendored_frameworks = "BWPlayer/Frameworks/*.framework"
         // 需要依赖的系统库
         s.frameworks = "AudioToolbox", "AVFoundation", "CoreGraphics", "CoreMedia", "CoreVideo", "MediaPlayer", "MobileCoreServices", "OpenGLES", "QuartzCore", "UIKit", "VideoToolbox"
         s.libraries = 'bz2','z','stdc++'
         s.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 armv7 armv7s'}
       end
       
       ```

        4. 构建完成后打开Example，此时可以顺利运行到手机。

##### 5. 发布自己的私有库

1. 创建私有的Spec Repo

   ```js
   // 成功之后将在~/.cocoapods/repo中看到 BWSpecs
   pod repo add BWSpecs https://github.com/bairdweng/BWSpecs.git
   ```

2. 设置tag，注意tag要跟s.version保持一致

3. 验证

   ```js
   pod lib lint BWPlayer.podspec  --skip-import-validation --allow-warnings
   ```

4. 提交podspec

   ```js
   // 本地的Space名称 & podspec
   pod repo push BWSpecs BWPlayer.podspec --skip-import-validation --allow-warnings
   ```

##### 6. 使用自己的私有库

1. Podfile中

   ```js
   // 设置源
   source 'https://github.com/bairdweng/BWSpecs.git'
   use_frameworks!
   platform :ios, '9.0'
   target 'BWPlayer_Example' do
     pod 'BWPlayer'
   end
   ```

2. 大文件的处理

   ```js
   // 初始化
   git lfs install
   // 添加大文件
   git lfs track "/BWPlayer/Frameworks/IJKMediaFramework.framework/IJKMediaFramework"
   // 正常上传即可
   ```

3. 注册cocoapods

   ```
   pod trunk register 644672334@qq.com "bairdweng" --description="bairdweng"
   ```

   
