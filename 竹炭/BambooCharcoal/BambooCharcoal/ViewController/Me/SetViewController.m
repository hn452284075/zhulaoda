//
//  SetViewController.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/30.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "SetViewController.h"
#import "ShowAlertView.h"
#import "UIView+Frame.h"
#import "AboutVC.h"
@interface SetViewController ()
@property (nonatomic,strong)UILabel *cacheLabel;
@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageTitle=@"设置";
    self.view.backgroundColor = KViewBgColor;
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth, 50)];
    subView.backgroundColor = [UIColor whiteColor];
    WEAK_SELF
    [subView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weak_self clearCache];
    }];
    [self.view addSubview:subView];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 50)];
    titleLabel.textColor = UIColorFromRGB(0x3333333);
    titleLabel.textAlignment=0;
    titleLabel.text = @"清除缓存";
    titleLabel.font=CUSTOMFONT(14);
    [subView addSubview:titleLabel];
    
    
    self.cacheLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-14-100, 0, 100, 50)];
    self.cacheLabel.textColor = UIColorFromRGB(0x333333);
    self.cacheLabel.textAlignment=2;
    self.cacheLabel.text =[NSString stringWithFormat:@"%.2fM",[self folderSize]];
    self.cacheLabel.font=CUSTOMFONT(14);
    [subView addSubview:self.cacheLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 65, kScreenWidth-15, 0.5)];
    lineView.backgroundColor = KLineColor;
    [self.view addSubview:lineView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, lineView.bottom, kScreenWidth, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 50)];
   titleLabel2.textColor = UIColorFromRGB(0x3333333);
   titleLabel2.textAlignment=0;
   titleLabel2.text = @"关于我们";
   titleLabel2.font=CUSTOMFONT(14);
   [view addSubview:titleLabel2];
   
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-10-13, 19, 13, 13)];
    [imgView setImage:IMAGE(@"rightArrow")];
    [view addSubview:imgView];
    
    [view addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weak_self _jumpAboutVC];
    }];
}

-(void)_jumpAboutVC{
    AboutVC *vc = [[AboutVC alloc]init];
    [self navigatePushViewController:vc animate:YES];

}
-(void)clearCache{
    WEAK_SELF
    [self showSimplyAlertWithTitle:@"提示" message:@"确定清除缓存吗?" sureAction:^(UIAlertAction *action) {
        [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
            weak_self.cacheLabel.text= [NSString stringWithFormat:@"%.2fM",[weak_self folderSize]];
            [weak_self showSuccessInfoWithStatus:@"清除成功"];
    
        }];
    } cancelAction:^(UIAlertAction *action) {
        
    }];
    

}

// 缓存大小
- (CGFloat)folderSize{
  

    SDImageCache *cache = [SDImageCache sharedImageCache];
    
     NSUInteger cacheSize = cache.totalDiskSize;
    
    
    return cacheSize/1000.0/1000;
}

 

@end
