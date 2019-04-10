# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'Deploy' do
use_frameworks!

# Pods for Project
pod 'FacebookCore'
pod 'FacebookLogin'
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
