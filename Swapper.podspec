#
# Be sure to run `pod lib lint Swapper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Swapper'
  s.version          = '0.2.1'
  s.summary          = 'UIView that can swap between child views you provide.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  You know those moments in your app when you have a `UITableView` that has no rows to show? You know those moments when you perform a HTTP network request and you want to show a non-blocking loading view to the user? These are very common scenarios for mobile apps. Swapper is a `UIView` that allows you to swap between a set of other `UIView`s with just 1 line of code. 
                         DESC

  s.homepage         = 'https://github.com/levibostian/Swapper-iOS'  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Levi Bostian' => 'levi@curiosityio.com' }
  s.source           = { :git => 'https://github.com/levibostian/Swapper-iOS.git', :tag => s.version.to_s }  

  s.ios.deployment_target = '9.3'
  s.swift_versions = "5.3" # Note: Also change in `.swift-version` file.

  s.source_files = 'Swapper/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Swapper' => ['Swapper/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
