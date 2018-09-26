Pod::Spec.new do |s|
          #1.
          s.name               = "KUPamba"
          #2.
          s.version            = "0.0.1"
          #3.  
          s.summary         = "KUPamba"
          #4.
          s.homepage        = "https://pambashare.com/"
          #5.
          s.license              = "MIT"
          #6.
          s.author               = "Truk"
          #7.
          s.platform            = :ios, "9.0"
          #8.
          s.source              = { :git => "https://github.com/phonephone/KUPamba.git", :tag => "s.version.to_s" }
          #9.
          s.source_files     = "KUPamba", "KUPamba/**/*.{h,m,swift}"
	  s.resources     = "KUPamba/**/*.{xcassets,storyboard,xib,xcdatamodeld,lproj,ttf,bundle,strings}"

s.static_framework = true

s.dependency 'MFSideMenu'
s.dependency 'CarbonKit'
s.dependency "AFNetworking", "~> 2.0"
s.dependency "SDWebImage"
s.dependency 'SVProgressHUD'
s.dependency 'IQKeyboardManager'
s.dependency "CCMPopup"
s.dependency 'FTPopOverMenu', '~>2.0.0'
s.dependency 'ISMessages'
s.dependency 'GooglePlaces'
s.dependency 'SCBPay', '~>1.0.1'

end