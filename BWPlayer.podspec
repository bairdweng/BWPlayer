#
# Be sure to run `pod lib lint BWPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

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
  s.source_files = 'BWPlayer/Frameworks/IJKMediaFramework.framework/Headers/**/*.{h,m,swift}'
  s.vendored_frameworks = "BWPlayer/Frameworks/IJKMediaFramework.framework"
  s.frameworks = "AudioToolbox", "AVFoundation", "CoreGraphics", "CoreMedia", "CoreVideo", "MediaPlayer", "MobileCoreServices", "OpenGLES", "QuartzCore", "UIKit", "VideoToolbox"
  s.libraries = 'bz2','z','stdc++'
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 armv7 armv7s'}
end
