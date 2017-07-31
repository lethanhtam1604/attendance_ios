source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

def shared_pods
    pod 'PureLayout'
    pod 'FontAwesomeKit'
    pod 'IQKeyboardManager'
    pod 'STPopup'
    pod 'SwiftOverlays'
    pod 'DZNEmptyDataSet'
    pod 'SDWebImage'
    pod 'Alamofire'
    pod 'DropDown'
    pod 'INSPhotoGallery'
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'Firebase/Auth'
    pod 'Firebase/Storage'
    pod 'Firebase/Messaging'
    pod 'OpenCV', '~> 2.4'
    pod 'EAIntroView'
    pod 'FSCalendar'
end

target 'Attendance' do
    shared_pods
end

target 'AttendanceUser' do
    shared_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
