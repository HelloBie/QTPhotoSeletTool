# QTPhotoSeletTool

一行代码实现上传图片场景中的图片选择逻辑,包含拍照和相册选择逻辑,内置权限判断,未授权跳转设置页面逻辑代码,可以实现简单的图片选择场景,用这个就不用再写那些授权,代理的代码了,还是比较方便的。
写的有点仓促,如果要用多测测,发现问题会更新,性能稳定之后会支持cocoapods

代码示例:
    [QTPhotoSeletTool showSelectPhotoAlertWithViewController:self resultBlock:^(UIImage *resultImage) {
        self.showImageView.image = resultImage;
    } unauthorizedBlock:nil];

