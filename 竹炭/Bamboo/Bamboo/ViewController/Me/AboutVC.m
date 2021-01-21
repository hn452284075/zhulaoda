//
//  AboutVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/10/9.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "AboutVC.h"
#import "UIView+Frame.h"
#import "Util.h"
@interface AboutVC ()

@end

@implementation AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageTitle=@"关于我们";
    self.view.backgroundColor = KViewBgColor;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-76/2, 95, 76, 76)];
    [imgView setImage:IMAGE(@"login_logo")];
    [self.view addSubview:imgView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-120/2, imgView.bottom+24, 120, 40)];
    titleLabel.textColor = UIColorFromRGB(0x222222);
    titleLabel.textAlignment=1;
    titleLabel.text = @"竹老大";
    titleLabel.font=CUSTOMFONT(34);
    [self.view addSubview:titleLabel];
    
    UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-100/2, titleLabel.bottom+24, 100, 20)];
    titleLabel2.textColor = UIColorFromRGB(0x999999);
    titleLabel2.textAlignment=1;
    titleLabel2.text = [NSString stringWithFormat:@"V%@",[Util appVersionStr]];
    titleLabel2.font=CUSTOMFONT(15);
    [self.view addSubview:titleLabel2];
    
    
    UILabel *titleLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2-120/2, kScreenHeight-40-38-kStatusBarAndNavigationBarHeight, 120, 40)];
    titleLabel3.textColor = UIColorFromRGB(0x999999);
    titleLabel3.textAlignment=1;
    titleLabel3.numberOfLines=2;
    titleLabel3.text = [NSString stringWithFormat:@"Copyright©2020\n竹老大版权所有"];
    titleLabel3.font=CUSTOMFONT(14);
    [self.view addSubview:titleLabel3];
    
}

 


@end
