Pod::Spec.new do |s|
  s.name             = 'AppLogs'
  s.version          = '0.1.0'
  s.summary          = 'A helper for OSLogStore.'

  s.description      = <<-DESC
                       AppLogs provides a simple interface for setting up an OSLogStore
                       and retrieving logs within a specified process. It's designed to work
                       with iOS 15.0 and later.
                       DESC

  s.homepage         = 'https://example.com/AppLogs'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kiryl Ziusko' => 'kiryl@margelo.io' }
  s.source           = { :git => 'https://example.com/AppLogs.git', :tag => s.version.to_s }

  s.module_name = 'AppLogs'

  s.source_files = '**/*.{h,m,mm,swift}'
  s.public_header_files = '**/*.h'
  s.swift_version = '5.0'
end