platform :ios, '6.0'

pod 'ReactiveCocoa', '~> 2.1.8'
pod 'MagicalRecord', '~> 2.2'
pod 'CocoaLumberjack', '~> 1.6.5.1'

post_install do |installer|
    installer.project.targets.each do |target|
        target.build_configurations.each do |config|
            s = config.build_settings['GCC_PREPROCESSOR_DEFINITIONS']
            s ||= [ '$(inherited)' ]
            s.push('MR_ENABLE_ACTIVE_RECORD_LOGGING=0');
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = s
        end
    end
end