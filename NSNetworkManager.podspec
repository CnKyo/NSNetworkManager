Pod::Spec.new do |s|

  s.name         = "NSNetworkManager"
  s.version      = "1.0.0"
  s.summary      = "基于YYCache和AFNetworking封装的网络状态监听以及请求库"
  s.homepage     = "https://github.com/GREENBANYAN/NSNetworkManager.git"
  s.license      = "MIT"
  s.author       = { "GREENBANYAN" => "@greenbanyan@163.com" }
  s.platform     = :ios,'8.0'
  s.source = { :git => 'https://github.com/GREENBANYAN/NSNetworkManager.git', :tag => s.version.to_s }
  s.source_files  = "NSNetworkManager/*.{h,m}"
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 3.1.0'
  s.dependency 'YYCache', '~> 1.0.4'

end