//
//  ViewController.m
//  QTPhotoSeletTool
//
//  Created by MasterBie on 2023/4/19.
//

#import "ViewController.h"
#import "QTPhotoSeletTool.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 提前调用,避免弹窗延迟
    [QTPhotoSeletTool initManager];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)click:(id)sender {
    [QTPhotoSeletTool showSelectPhotoAlertWithViewController:self resultBlock:^(UIImage *resultImage) {
        self.showImageView.image = resultImage;
    } unauthorizedBlock:nil];
}


@end
