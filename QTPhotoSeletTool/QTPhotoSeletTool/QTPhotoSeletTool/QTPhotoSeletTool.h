//
//  QTPhotoSeletTool.h
//  QTPhotoSeletTool
//
//  Created by MasterBie on 2023/4/19.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>


@interface QTPhotoSeletTool : NSObject

#pragma mark - 选择相关

/// 弹出上传图片弹窗,包含相册和相机,带有权限判断逻辑
/// - Parameters:
///   - vc: 当前vc
///   - resultHandle: 选择图片(拍照)回调
///   - unauthorizedHandler: 未授权回调,传nil会自动弹出提示框
+ (void)showSelectPhotoAlertWithViewController:(UIViewController *)vc
                                   resultBlock:(void(^)(UIImage *resultImage))resultHandle
                             unauthorizedBlock:(void(^)(PHAuthorizationStatus status))unauthorizedHandler;

/// 弹出上传图片弹窗,包含相册和相机,不带有权限判断逻辑
/// - Parameters:
///   - vc: 当前vc
///   - resultHandle: 选择图片(拍照)回调
+ (void)showSelectPhotoAlertWithViewController:(UIViewController *)vc
                                   resultBlock:(void(^)(UIImage *resultImage))resultHandle;

#pragma mark - 权限相关

/// 确认相机权限,带有请求权限功能
/// - Parameters:
///   - vc: 当前vc
///   - authorizedHandle: 已授权回调
///   - unauthorizedHandler: 未授权回调,传nil会自动弹出去设置提示框
+ (void)confirmCameraPermissionsWithViewController:(UIViewController *)vc
                                   authorizedBlock:(void(^)(void))authorizedHandle
                                 unauthorizedBlock:(void(^)(AVAuthorizationStatus status))unauthorizedHandler;

/// 确认相册权限,带有请求权限功能
/// - Parameters:
///   - vc: 当前vc
///   - authorizedHandle: 已授权回调
///   - unauthorizedHandler: 未授权回调,传nil会自动弹出去设置提示框
+ (void)confirmAlbumPermissionsWithViewController:(UIViewController *)vc
                                  authorizedBlock:(void(^)(void))authorizedHandle
                                unauthorizedBlock:(void(^)(PHAuthorizationStatus status))unauthorizedHandler;

/// 建议在适当的时候提前调用此初始化方法,可以避免弹窗延迟
+ (void)initManager;
@end


