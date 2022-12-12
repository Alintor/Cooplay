platform :ios, '13.0'

source 'https://github.com/CocoaPods/Specs.git'

target 'Cooplay' do
  use_frameworks!

  pod 'Swinject', '~> 2.6.2'
  pod 'SwinjectStoryboard', '~> 2.2.0'
  pod 'R.swift', '~> 5.0.3'
  pod 'PluggableAppDelegate', '~> 1.3.0'
  pod 'Kingfisher', '~> 5.8.1'
  pod 'SwiftDate', '~> 4.5.1'
  pod 'DTTableViewManager'
  pod 'DTCollectionViewManager', '~> 8.2.0'
  pod 'iCarousel', '~> 1.8.3'
  pod 'KDCalendar', '~> 1.8.9'
  pod 'Moya', '~> 13.0.1'
  pod 'SwiftyJSON', '~> 5.0.0'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/DynamicLinks'
  pod 'Firebase/Messaging'
  pod 'Firebase/Functions'
  pod 'UIImageColors'
  pod 'Kingfisher/SwiftUI'

  pod 'LightRoute', :git => 'https://github.com/SpectralDragon/LightRoute.git'

  target 'EventStatusNotification' do 
	inherit! :search_paths
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
    end
  end
end
