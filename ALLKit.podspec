Pod::Spec.new do |s|
  s.name                       = 'ALLKit'
  s.version                    = '0.0.1'
  s.summary                    = 'Async list layout kit'
  s.homepage                   = 'https://github.com/geor-kasapidi/ALLKit'
  s.license                    = { :type => 'MIT', :file => 'LICENSE' }
  s.author                     = { 'Georgy Kasapidi' => 'geor.kasapidi@icloud.com' }
  s.source                     = { :git => 'https://github.com/geor-kasapidi/ALLKit.git', :tag => "v#{s.version}" }
  s.platform                   = :ios, '8.0'
  s.swift_version              = '4'
  s.requires_arc               = true
  s.source_files               = 'Sources/*.swift'
  s.frameworks                 = 'Foundation', 'UIKit'
  s.dependency                   'Yoga', '1.6'
end
