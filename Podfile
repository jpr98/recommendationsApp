# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'

target 'recommendationsApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for recommendationsApp
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'FirebaseUI/Auth'
  pod 'Firebase/Database'
  pod 'FirebaseUI/Facebook'
  pod 'Cosmos'
  pod 'XLActionController'

  post_install do |installer|
      installer.pods_project.build_configurations.each do |config|
          config.build_settings.delete('CODE_SIGNING_ALLOWED')
          config.build_settings.delete('CODE_SIGNING_REQUIRED')
      end
  end

end
