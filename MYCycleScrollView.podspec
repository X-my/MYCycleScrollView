
Pod::Spec.new do |s|

  s.name         = "MYCycleScrollView"
  s.version      = "1.0.4"
  s.summary      = "Swift版无限滚动轮播图控件，使用Kingfisher加载网络图片"

  s.homepage     = "https://github.com/X-my/MYCycleScrollView"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.authors            = { "xmy" => "woshixmy@163.com" }
  s.platform     = :ios
  s.ios.deployment_target = "8.0"


  s.source       = { :git => "https://github.com/X-my/MYCycleScrollView.git", :tag => s.version }
  
  s.source_files  = ["Sources/*.swift"]

  s.requires_arc = true
  s.dependency 'Kingfisher'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => ‘4.0’ }
end