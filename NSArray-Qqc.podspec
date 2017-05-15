Pod::Spec.new do |s|

  s.license      = "MIT"
  s.author       = { "qqc" => "20599378@qq.com" }
  s.platform     = :ios, "8.0"
  s.requires_arc  = true

  s.name         = "NSArray-Qqc"
  s.version      = "1.0.10"
  s.summary      = "NSArray-Qqc"
  s.homepage     = "https://github.com/xukiki/NSArray-Qqc"
  s.source       = { :git => "https://github.com/xukiki/NSArray-Qqc.git", :tag => "#{s.version}" }
  
  s.source_files  = ["NSArray-Qqc/*.{h,m}"]

end
