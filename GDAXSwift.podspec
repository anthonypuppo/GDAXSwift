Pod::Spec.new do |s|
  s.name             = 'GDAXSwift'
  s.version          = '0.1.0'
  s.summary          = 'The unofficial Swift wrapper around the GDAX API'
  s.description      = 'The unofficial Swift wrapper around the GDAX API to allow easy programmatic trading and data querying'
  s.homepage         = 'https://github.com/anthonypuppo/GDAXSwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Anthony Puppo' => 'anthonypuppo123@gmail.com' }
  s.source           = { :git => 'https://github.com/anthonypuppo/GDAXSwift.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = "10.10"
  s.source_files = 'GDAXSwift/Classes/**/*'
  s.dependency 'CryptoSwift'
end
