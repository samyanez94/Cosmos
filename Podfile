platform :ios, 13.0

inhibit_all_warnings!

target 'Cosmos' do
  
  use_frameworks!

  # Pods
    pod 'SwiftLint'
    pod 'Nuke', '~> 9.0'
    pod 'Lightbox', '~> 2.4.2'
    pod 'Toast-Swift', '~> 5.0.1'
end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
end
