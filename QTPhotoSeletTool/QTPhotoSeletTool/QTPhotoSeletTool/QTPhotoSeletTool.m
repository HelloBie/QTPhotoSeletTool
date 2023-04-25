//
//  QTPhotoSeletTool.m
//  QTPhotoSeletTool
//
//  Created by MasterBie on 2023/4/19.
//

#import "QTPhotoSeletTool.h"

static QTPhotoSeletTool* _instance = nil;

@interface QTPhotoSeletTool()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/// 系统相册选择器
@property(nonatomic,strong)UIImagePickerController *imagePicker;

/// 用来存储各种参数的Dic
@property(nonatomic,strong)NSMutableDictionary *paramsDic;

/// 当前调用
@property(nonatomic,weak)UIViewController *currentVC;
@end

@implementation QTPhotoSeletTool

#pragma mark - 对外暴露的方法

/// 弹出上传图片弹窗,包含相册和相机,带有权限判断逻辑
/// - Parameters:
///   - vc: 当前vc
///   - resultHandle: 选择图片(拍照)回调
///   - unauthorizedHandler: 未授权回调,传nil会自动弹出提示框
+ (void)showSelectPhotoAlertWithViewController:(UIViewController *)vc
                                   resultBlock:(void(^)(UIImage *resultImage))resultHandle
                             unauthorizedBlock:(void(^)(PHAuthorizationStatus status))unauthorizedHandler {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请选择" message:@"拍照或者从相册选取" preferredStyle:UIAlertControllerStyleActionSheet];
    [controller addAction: [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self confirmCameraPermissionsWithViewController:vc authorizedBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self shareInstance].imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [vc presentViewController: [self shareInstance].imagePicker animated:YES completion:nil];
            });
        } unauthorizedBlock:nil];
    }]];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [controller addAction: [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self confirmAlbumPermissionsWithViewController:vc authorizedBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self shareInstance].imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //图片来源
                    [vc presentViewController: [self shareInstance].imagePicker animated:YES completion:nil];
                });
            } unauthorizedBlock:nil];
        }]];
    }
    
    [controller addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[self shareInstance].paramsDic removeObjectForKey:NSStringFromClass(vc.class)];
        [self shareInstance].currentVC = nil;
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc presentViewController:controller animated:YES completion:nil];
    });
    [self shareInstance].paramsDic[NSStringFromClass(vc.class)] = @{
        @"block":resultHandle
    };
    [self shareInstance].currentVC = vc;
    
}


/// 弹出上传图片弹窗,包含相册和相机,不带有权限判断逻辑
/// - Parameters:
///   - vc: 当前vc
///   - resultHandle: 选择图片(拍照)回调
+ (void)showSelectPhotoAlertWithViewController:(UIViewController *)vc
                                   resultBlock:(void(^)(UIImage *resultImage))resultHandle{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"请选择" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [controller addAction: [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareInstance].imagePicker.allowsEditing = YES;
        [self shareInstance].imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera; //图片来源
        [vc presentViewController: [self shareInstance].imagePicker animated:YES completion:nil];
    }]];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [controller addAction: [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //[self shareInstance].imagePicker.allowsEditing = YES;
            [self shareInstance].imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //图片来源
            [vc presentViewController: [self shareInstance].imagePicker animated:YES completion:nil];
        }]];
    }
    
    [controller addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[self shareInstance].paramsDic removeObjectForKey:NSStringFromClass(vc.class)];
        [self shareInstance].currentVC = nil;
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [vc presentViewController:controller animated:YES completion:nil];
    });
    [self shareInstance].paramsDic[NSStringFromClass(vc.class)] = @{
        @"block":resultHandle
    };
    [self shareInstance].currentVC = vc;
    
}


/// 确认相机权限
/// - Parameters:
///   - vc: 当前vc
///   - authorizedHandle: 已授权回调
///   - unauthorizedHandler: 未授权回调,传nil会自动弹出提示框
+ (void)confirmCameraPermissionsWithViewController:(UIViewController *)vc
                                   authorizedBlock:(void(^)(void))authorizedHandle
                                 unauthorizedBlock:(void(^)(AVAuthorizationStatus status))unauthorizedHandler {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied) {
        //无权限
        if(unauthorizedHandler){
            unauthorizedHandler(authStatus);
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"相机权限未开启,请开启相机权限" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                }];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertController addAction:confirm];
                [alertController addAction:cancel];
                [vc presentViewController:alertController animated:YES completion:nil];
            });
        }
        return ;
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (!granted) {//不允许
                if(unauthorizedHandler){
                    unauthorizedHandler(authStatus);
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"相机权限未开启,请开启相机权限" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                        }];
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        [alertController addAction:confirm];
                        [alertController addAction:cancel];
                        [vc presentViewController:alertController animated:YES completion:nil];
                    });
                }
            }else{//开启
                authorizedHandle();
            }
        }];
        return;
    }else{
        //已授权
        authorizedHandle();
    }
}

/// 确认相册权限
/// - Parameters:
///   - vc: 当前vc
///   - authorizedHandle: 已授权回调
///   - unauthorizedHandler: 未授权回调,传nil会自动弹出提示框
+ (void)confirmAlbumPermissionsWithViewController:(UIViewController *)vc
                                  authorizedBlock:(void(^)(void))authorizedHandle
                                unauthorizedBlock:(void(^)(PHAuthorizationStatus status))unauthorizedHandler {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusAuthorized) {//相册权限已开启
                if(authorizedHandle){
                    authorizedHandle();
                }
            } else {
                if(unauthorizedHandler){
                    unauthorizedHandler((PHAuthorizationStatus)status);
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"相册权限未开启,请开启相册权限" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                        }];
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        [alertController addAction:confirm];
                        [alertController addAction:cancel];
                        [vc presentViewController:alertController animated:YES completion:nil];
                    });
                }
            }
        });
    }];
}

#pragma mark -实现图片选择器代理
///当用户选择好图片的时候，调用该方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    void(^block)(UIImage *resultImage) = self.paramsDic[NSStringFromClass(self.currentVC.class)][@"block"];
    if(block){
        block(image);
    }
    
    [self.paramsDic removeObjectForKey:NSStringFromClass(self.currentVC.class)];
    self.currentVC = nil;
}

///当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    [self.paramsDic removeObjectForKey:NSStringFromClass(self.currentVC.class)];
    self.currentVC = nil;
}


#pragma mark - 单例相关

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
        //不是使用alloc方法，而是调用[[super allocWithZone:NULL] init]
        //已经重载allocWithZone基本的对象分配方法，所以要借用父类（NSObject）的功能来帮助出处理底层内存分配的杂物
        if(_instance){
            _instance.imagePicker = [[UIImagePickerController alloc] init];
            _instance.imagePicker.delegate = _instance;
            _instance.paramsDic = @{}.mutableCopy;
        }
    }) ;
    return _instance ;
}

//用alloc返回也是唯一实例
+(id)allocWithZone:(struct _NSZone *)zone {
    return [QTPhotoSeletTool shareInstance] ;
}


//对对象使用copy也是返回唯一实例
-(id)copyWithZone:(NSZone *)zone {
    return [QTPhotoSeletTool shareInstance] ;//return _instance;
}


//对对象使用mutablecopy也是返回唯一实例
-(id)mutableCopyWithZone:(NSZone *)zone {
    return [QTPhotoSeletTool shareInstance] ;
}
@end
