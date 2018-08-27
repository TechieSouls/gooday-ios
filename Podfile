# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'Cenes' do
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
pod 'p2.OAuth2', '~> 3.0.3'
pod 'SideMenu'
pod 'GoogleAnalytics'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end


end
