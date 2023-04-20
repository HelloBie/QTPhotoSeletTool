# QTPhotoSeletTool

一行代码实现上传图片场景中的图片选择逻辑,包含拍照和相册选择逻辑,内置权限判断,未授权跳转设置页面逻辑代码,可以实现简单的图片选择场景

代码示例:
    [QTPhotoSeletTool showSelectPhotoAlertWithViewController:self resultBlock:^(UIImage *resultImage) {
        self.showImageView.image = resultImage;
    } unauthorizedBlock:nil];

