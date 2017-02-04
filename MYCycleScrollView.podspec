
Pod::Spec.new do |s|


s.name         = “MYCycleScrollView"
s.version      = “0.1”
s.summary      = "Swift版无限滚动轮播图控件，使用Kingfisher加载网络图片"

s.homepage     = "https://github.com/X-my/MYCycleScrollView"

s.license      = "MIT"

s.author       = { “xmy” => “woshixmy@163.com” }

s.platform     = :ios
s.platform     = :ios, “8.0”


s.source       = { :git => "https://github.com/X-my/MYCycleScrollView.git", :tag => s.version}


s.source_files  = "Sources/*.swift"


s.requires_arc = true

s.dependency 'Kingfisher', '~> 3.3.3'

end