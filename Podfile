platform :ios, '13.0'

source 'https://github.com/CocoaPods/Specs.git'

target 'Cooplay' do
  use_frameworks!

  pod 'R.swift', '~> 5.0.3'
  pod 'SwiftDate', '~> 7.0.0'
  pod 'iCarousel', '~> 1.8.3'
  pod 'Moya', '~> 13.0.1'
  pod 'SwiftyJSON', '~> 5.0.0'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/DynamicLinks'
  pod 'Firebase/Messaging'
  pod 'Firebase/Functions'
  pod 'FirebaseCrashlytics'
  pod 'Firebase/Storage'
  pod 'Kingfisher/SwiftUI'
  pod 'GoogleSignIn'

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
