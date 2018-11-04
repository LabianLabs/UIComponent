#
# Be sure to run `pod lib lint UIComponent.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'UIComponent'
  s.version          = '0.1.51'
  s.summary          = 'Lightweight UI library for iOS app'
  s.description      = <<-DESC
This pod is Under development
                       DESC
  s.homepage         = 'https://github.com/LabianLabs/UIComponent.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Created by labs01' => 'labianlabs@gmail.com' }
  s.source           = { :git => 'https://github.com/LabianLabs/UIComponent.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'UIComponent/Classes/**/*'
  s.frameworks = 'UIKit', 'Foundation'
  #s.dependency 'Eureka', '~> 4.1.1'
  s.requires_arc = true
  s.swift_version = '4.0'
end
