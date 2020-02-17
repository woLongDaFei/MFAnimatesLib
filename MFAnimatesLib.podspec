#
#  Be sure to run `pod spec lint MFAnimatesLib.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "MFAnimatesLib"

  spec.version      = "0.0.1"

  spec.summary      = "A short description of MFAnimatesLib."

  spec.description  = "动画描述"

  spec.homepage     = "https://github.com/woLongDaFei/MFAnimatesLib"

  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  spec.author             = { "赵永斐" => "zhaoyongfei2008@163.com" }

  spec.platform     = :ios, "9.0"

  spec.source       = { :git => "https://github.com/woLongDaFei/MFAnimatesLib.git", :tag => s.version.to_s }

  spec.source_files  = "AnimateFlie/classes/**/*.{h,m}"

  spec.requires_arc = true

  spec.dependency "SVGAPlayer"

end
