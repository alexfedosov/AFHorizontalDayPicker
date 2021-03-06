#
# Be sure to run `pod lib lint AFHorizontalDayPicker.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "AFHorizontalDayPicker"
  s.version          = "0.2.0"
  s.summary          = "AFHorizontalDayPicker is clean and simple day picker based on UICollectionView"
  s.homepage         = "https://github.com/alexfedosov/AFHorizontalDayPicker"
  s.screenshots     = "https://raw.github.com/alexfedosov/AFHorizontalDayPicker/master/Screens/2.png", "https://raw.github.com/alexfedosov/AFHorizontalDayPicker/master/Screens/animation.gif"
  s.license          = 'MIT'
  s.author           = { "Alexander Fedosov" => "alexander.a.fedosov@gmail.com" }
  s.source           = { :git => "https://github.com/alexfedosov/AFHorizontalDayPicker.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'AFHorizontalDayPicker' => ['Pod/Assets/*.png']
  }

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
  s.dependency 'MTDates', '1.0.0'
end
