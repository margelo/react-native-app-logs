Pod::Spec.new do |s|
  s.name             = 'OSLogStoreHelper'
  s.version          = '0.1.0'
  s.summary          = 'A helper for OSLogStore.'

  s.description      = <<-DESC
                       A longer description of OSLogStoreHelper in Markdown format.
                       DESC

  s.homepage         = 'https://example.com/OSLogStoreHelper'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kiryl Ziusko' => 'kiryl@margelo.io' }
  s.source           = { :git => 'https://example.com/OSLogStoreHelper.git', :tag => s.version.to_s }

  s.module_name = 'OSLogStoreHelper'

  s.source_files = '**/*.{h,m,mm,swift}'
  s.public_header_files = '**/*.h'
  s.swift_version = '5.0'
end