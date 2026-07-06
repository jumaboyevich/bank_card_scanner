#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint bank_card_scanner.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'bank_card_scanner'
  s.version          = '0.0.1'
  s.summary          = 'On-device bank card scanner for Flutter.'
  s.description      = <<-DESC
On-device bank card scanner. Recognizes the card number and expiry date with
the camera using Apple's Vision framework, fully offline.
                       DESC
  s.homepage         = 'https://github.com/jumaboyevich/bank_card_scanner'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Taqsit' => 'ilxomjon.asraqulov@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'bank_card_scanner/Sources/bank_card_scanner/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'bank_card_scanner_privacy' => ['bank_card_scanner/Sources/bank_card_scanner/PrivacyInfo.xcprivacy']}
end
