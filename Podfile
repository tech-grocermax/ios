# Uncomment this line to define a global platform for your project
# platform :ios, '7.0'

target 'GrocerMax' do
    pod 'AFNetworking', '~> 2.6'
    pod 'TPKeyboardAvoiding', '~> 1.2'
    pod 'SVProgressHUD', '~> 1.1'
    pod 'RaisinToast'
    pod 'Google/SignIn', '~> 1.0.0'
    pod 'Mantle', '~> 2.0'
    pod 'MMDrawerController', '~> 0.6'
    pod 'Google/Analytics'
    pod 'FBSDKCoreKit', '~> 4.8'
    pod 'FBSDKLoginKit', '~> 4.8'
    pod 'quantumgraph'

end

post_install do |installer|
    `/usr/libexec/PlistBuddy -c "Delete :CFBundleSupportedPlatforms" ./Pods/GoogleSignIn/Resources/GoogleSignIn.bundle/Info.plist`
    `/usr/libexec/PlistBuddy -c "Delete :CFBundleExecutable" ./Pods/GoogleSignIn/Resources/GoogleSignIn.bundle/Info.plist`
end

target 'GrocerMaxTests' do

end

