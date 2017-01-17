# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
# Uncomment this line if you're using Swift
use_frameworks!

target 'ios' do
  pod 'Firebase'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'FirebaseUI/Storage', '~> 0.6'
  pod 'SSZipArchive'
  pod 'SDWebImage', '~>3.8'
  pod 'SwiftyJSON'
end

target 'iosTests' do
  pod 'Firebase'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'FirebaseUI/Storage', '~> 0.6'
  pod 'SSZipArchive'
  pod 'SDWebImage', '~>3.8'
  pod 'SwiftyJSON'
end

target 'iosUITests' do
  pod 'Firebase'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'Firebase/Storage'
  pod 'FirebaseUI/Storage', '~> 0.6'
  pod 'SSZipArchive'
  pod 'SDWebImage', '~>3.8'
  pod 'SwiftyJSON'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0' #'3.0'
    end
  end
end
