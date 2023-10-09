

Pod::Spec.new do |spec|


  spec.name         = "QTPhotoSeletTool"
  spec.version      = "0.01"
  spec.summary      = "一行代码拿到相册或者拍照图片"

  spec.description  = "QTPhotoSeletTool"

  spec.homepage     = "https://github.com/HelloBie/QTPhotoSeletTool"


  spec.ios.deployment_target = '9.0'
  spec.license      = "MIT"

  spec.author             = { "bieqiutian" => "1005903848@qq.com" }

  spec.source       = { :git => "https://github.com/HelloBie/QTPhotoSeletTool.git", :tag => "#{spec.version}" }


  spec.source_files  = "QTPhotoSeletTool/QTPhotoSeletTool/QTPhotoSeletTool/*.{h,m}"
  
  spec.frameworks = "Foundation", "UIKit"

end
