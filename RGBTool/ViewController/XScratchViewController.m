//
//  XScratchViewController.m
//  RGBTool
//
//  Created by admin on 23/08/2017.
//  Copyright © 2017 yang. All rights reserved.
//

#import "XScratchViewController.h"
#import "XScratchView.h"
#import "XRGBTool.h"

@interface XScratchViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/** 画马赛克View */
@property (nonatomic, strong) XScratchView *scratchView;
/** resultImageView */
@property (nonatomic, strong) UIImageView *resultImageView;

@end

@implementation XScratchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
}

-(void)setupUI{
    XScratchView *scratchView = [[XScratchView alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, 300)];
    scratchView.surfaceImage = [UIImage imageNamed:@"123.jpeg"];
    scratchView.mosaicImage = [XRGBTool getMosaicImageWith:[UIImage imageNamed:@"123.jpeg"] level:0];
    _scratchView = scratchView;
    [self.view addSubview:scratchView];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(0, 420, kScreenWidth/3.0, 30);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    UIButton *recoverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recoverBtn.frame = CGRectMake(kScreenWidth/3.0, 420, kScreenWidth/3.0, 30);
    [recoverBtn setTitle:@"复原" forState:UIControlStateNormal];
    [recoverBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [recoverBtn addTarget:self action:@selector(recover) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recoverBtn];
    
    UIButton *picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    picBtn.frame = CGRectMake(kScreenWidth/3.0*2, 420, kScreenWidth/3.0, 30);
    [picBtn setTitle:@"更换图片" forState:UIControlStateNormal];
    [picBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [picBtn addTarget:self action:@selector(selectPic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:picBtn];
    
    UIImageView *resultImageView = [[UIImageView alloc] init];
    resultImageView.frame = CGRectMake(50, 460, kScreenWidth-100, 210);
    _resultImageView = resultImageView;
    [self.view addSubview:resultImageView];

}
#pragma mark --- private Events
- (void)save{
    __weak typeof(self) weakSelf = self;
    UIGraphicsBeginImageContextWithOptions(weakSelf.scratchView.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [weakSelf.scratchView.layer renderInContext:context];
    UIImage *deadledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    weakSelf.resultImageView.image = deadledImage;
    
}

- (void)recover{
    [_scratchView recover];
}

- (void)selectPic{
    UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//选择照片源
    imagePickerVC.delegate = self;
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [_scratchView recover];
    UIImage *selectedImage = info[UIImagePickerControllerOriginalImage];
    _scratchView.surfaceImage = selectedImage;
    _scratchView.mosaicImage = [XRGBTool getMosaicImageWith:selectedImage level:0];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
