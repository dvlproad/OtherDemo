Pod::Spec.new do |s|
	#验证方法1：pod lib lint TSDemo_VoiceRecognition.podspec --sources='https://github.com/CocoaPods/Specs.git,https://gitee.com/dvlproad/dvlproadSpecs' --allow-warnings --use-libraries --verbose
  #验证方法2：pod lib lint TSDemo_VoiceRecognition.podspec --sources=master,dvlproad --allow-warnings --use-libraries --verbose
  #提交方法： pod repo push dvlproad TSDemo_VoiceRecognition.podspec --sources=master,dvlproad --allow-warnings --use-libraries --verbose
  s.name         = "TSDemo_VoiceRecognition"
  s.version      = "0.1.0"
  s.summary      = "语音笔记 VoiceRecognition 演示示例"
  s.homepage     = "https://gitee.com/dvlproad/UIKit-Guide-iOS.git"

  #s.license      = "MIT"
  s.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
              © 2008-2016 dvlproad. All rights reserved.
    LICENSE
  }

  s.author   = { "dvlproad" => "" }
  

  s.description  = <<-DESC
 				          -、演示示例

                   A longer description of TSDemo_VoiceRecognition in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC
  

  s.platform     = :ios, "8.0"
 
  s.source       = { :git => "https://gitee.com/dvlproad/UIKit-Guide-iOS.git", :tag => "TSDemo_VoiceRecognition_0.1.0" }
  #s.source_files  = "CJDemoCommon/*.{h,m}"
  #s.source_files = "CJChat/TestOSChinaPod.{h,m}"

  s.frameworks = "UIKit"
  # [关于制作私有pod库包含framework和.a文件时遇到的一些问题](https://blog.csdn.net/w_shuiping/article/details/80606277)
  # s.vendored_libraries = 'WoqiSDK/Classes/*.a'
  s.vendored_frameworks = 'TSDemo_VoiceRecognition/Framework/**/*.framework'

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"


  # TSDemo_VoiceRecognition
  s.source_files = "TSDemo_VoiceRecognition/Src/**/*.{h,m}"
  s.resource_bundle = {
    'TSDemo_VoiceRecognition' => ['TSDemo_VoiceRecognition/**/*.{png,jpg}'] # TSDemo_VoiceRecognition 为生成boudle的名称，可以随便起，但要记住，库里要用
  }
  #多个依赖就写多行
  s.dependency 'SVProgressHUD'
  s.dependency 'Masonry'
  s.dependency 'CJBaseUIKit/UIColor'
  s.dependency 'Colours'
  
end
