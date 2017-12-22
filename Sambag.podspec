Pod::Spec.new do |s|
  s.name     = 'Sambag'
  s.version  = '1.0'
  s.summary  = 'Android Time, Month-Year, and Date pickers implemented in Swift for iOS development'
  s.platform = :ios, '9.0'
  s.license  = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage = 'https://github.com/mownier/sambag'
  s.author   = { 'Mounir Ybanez' => 'rinuom91@gmail.com' }
  s.source   = { :git => 'https://github.com/mownier/sambag.git', :tag => s.version.to_s }
  s.source_files = 'Sambag/Source/*.swift'
  s.requires_arc = true
end
