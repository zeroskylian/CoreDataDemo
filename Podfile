# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings! #忽略pod库警告


target 'SwiftProject' do
  pod 'Kingfisher'
  pod 'Alamofire'
  pod 'Moya'
  pod 'SnapKit'
  pod 'Reusable'
  pod 'FluentDarkModeKit','0.5.1'
  
end

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      #      config.build_settings['SDKROOT'] = 'iphoneos10.3'
      #      config.build_settings['APPLICATION_EXTENSION_API_ONLY'] = 'NO'
      config.build_settings['inhibit_all_warnings'] = 'YES'
    end
  end
end
