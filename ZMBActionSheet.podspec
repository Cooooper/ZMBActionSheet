#
#  Be sure to run `pod spec lint ZMBActionSheet.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|


  s.name         = "ZMBActionSheet"
  s.version      = "1.0.0"
  s.summary      = "It is similar to UIActionSheet."

  s.description  = <<-DESC 
                  It is similar to UIActionSheet.这是一个类似于系统的UIActionSheet,最低支持到iOS 7，api完全仿照UIActionSheet.使用起来简单方便。
                   DESC

  s.homepage     = "https://github.com/Cooooper/ZMBActionSheet"

  s.license      = "MIT"

  s.author       = { "Han Yahui" => "idevhan@gmail.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/Cooooper/ZMBActionSheet.git", :tag => "1.0.0" }

  s.source_files  = "ActionSheet/*"

  s.requires_arc = true


end
