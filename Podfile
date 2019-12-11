# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'Cenes' do
use_frameworks!

# Pods for Project
pod 'FBSDKCoreKit', '~> 4.38.0'
pod 'FBSDKLoginKit', '~> 4.38.0'
pod 'IoniconsSwift'
pod 'FSCalendar'
pod 'Alamofire', '~> 4.4'
pod 'ActionButton'
pod 'Google/SignIn'
pod 'NVActivityIndicatorView'
pod 'p2.OAuth2', '~> 4.2'
pod 'SideMenu'
pod 'GoogleAnalytics'
pod 'SwiftyJSONModel'
pod 'SDWebImage', '~> 4.0'
pod 'VisualEffectView'
pod 'SwipeCellKit'
pod 'Mantis', '~> 0.43'
pod 'Fabric'
pod 'Crashlytics'
pod 'ReachabilitySwift'
pod 'SQLite.swift', '~> 0.12.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.0'
      config.build_settings.delete('CODE_SIGNING_ALLOWED')
      config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
  end
end


end
