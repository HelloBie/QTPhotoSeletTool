# QTPhotoSeletTool

一行代码拿到相册或者拍照图片

代码示例:
    [QTPhotoSeletTool showSelectPhotoAlertWithViewController:self resultBlock:^(UIImage *resultImage) {
        self.showImageView.image = resultImage;
    } unauthorizedBlock:nil];

