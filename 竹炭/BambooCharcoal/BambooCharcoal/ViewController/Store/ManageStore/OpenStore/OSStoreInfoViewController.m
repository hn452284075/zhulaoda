//
//  OSStoreInfoViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/10/17.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "OSStoreInfoViewController.h"

@interface OSStoreInfoViewController ()

@end

@implementation OSStoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    self.pageTitle = @"网店信息";
    
    [self _initInfoView];
    
}

#pragma mark ------------------------init---------------------------------
- (void)_initInfoView
{
    CGSize size = [self sizeWithText:self.smodel.major font:CUSTOMFONT(14) maxSize:CGSizeMake(kScreenWidth-100-30, 300)];
    
    UIView *backview = [[UIView alloc] init];
    backview.layer.cornerRadius = 5.0;
    backview.layer.masksToBounds = YES;
    [self.view addSubview:backview];
    backview.backgroundColor = [UIColor whiteColor];
    [backview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(15);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(size.height+188);
    }];
    
    UILabel *lab1 = [[UILabel alloc] init];
    [self customLabel:lab1 text:@"店铺信息"];
    [backview addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backview.mas_top).offset(20);
        make.left.equalTo(backview.mas_left).offset(12);
        make.height.equalTo(@13);
        make.width.equalTo(@60);
    }];
        
    UILabel *lab1_value = [[UILabel alloc] init];
    [self customLabel:lab1_value text:self.smodel.shopName];
    [backview addSubview:lab1_value];
    [lab1_value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab1.mas_centerY);
        make.left.equalTo(lab1.mas_right).offset(20);
        make.right.equalTo(backview.mas_right).offset(-20);
        make.height.equalTo(@13);
    }];
    
    UIView *lineview1 = [[UIView alloc] init];
    lineview1.backgroundColor = [UIColor lightGrayColor];
    lineview1.alpha = 0.3;
    [backview addSubview:lineview1];
    [lineview1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1.mas_bottom).offset(18);
        make.left.equalTo(lab1_value.mas_left).offset(0);
        make.right.equalTo(lab1_value.mas_right).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    [backview addSubview:lineview1];
    
    UILabel *lab2 = [[UILabel alloc] init];
    [self customLabel:lab2 text:@"申请人"];
    [backview addSubview:lab2];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineview1.mas_bottom).offset(17);
        make.left.equalTo(backview.mas_left).offset(12);
        make.height.equalTo(@13);
        make.width.equalTo(@60);
    }];

    UILabel *lab2_value = [[UILabel alloc] init];
    [self customLabel:lab2_value text:self.smodel.ownerRealName];
    [backview addSubview:lab2_value];
    [lab2_value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab2.mas_centerY);
        make.left.equalTo(lab2.mas_right).offset(20);
        make.right.equalTo(backview.mas_right).offset(-20);
        make.height.equalTo(@13);
    }];

    UIView *lineview2 = [[UIView alloc] init];
    lineview2.backgroundColor = [UIColor lightGrayColor];
    lineview2.alpha = 0.3;
    [backview addSubview:lineview2];
    [lineview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab2.mas_bottom).offset(18);
        make.left.equalTo(lab2_value.mas_left).offset(0);
        make.right.equalTo(lab2_value.mas_right).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    [backview addSubview:lineview2];



    UILabel *lab3 = [[UILabel alloc] init];
    [self customLabel:lab3 text:@"主营品类"];
    [backview addSubview:lab3];
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineview2.mas_bottom).offset(17);
        make.left.equalTo(backview.mas_left).offset(12);
        make.height.equalTo(@13);
        make.width.equalTo(@60);
    }];

    UILabel *lab3_value = [[UILabel alloc] init];
    [self customLabel:lab3_value text:self.smodel.major];
    [backview addSubview:lab3_value];
    [lab3_value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab3.mas_top);
        make.left.equalTo(lab3.mas_right).offset(20);
        make.right.equalTo(backview.mas_right).offset(-20);
        make.height.mas_equalTo(size.height);
    }];

    UIView *lineview3 = [[UIView alloc] init];
    lineview3.backgroundColor = [UIColor lightGrayColor];
    lineview3.alpha = 0.3;
    [backview addSubview:lineview3];
    [lineview3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab3_value.mas_bottom).offset(18);
        make.left.equalTo(lab3_value.mas_left).offset(0);
        make.right.equalTo(lab3_value.mas_right).offset(0);
        make.height.mas_equalTo(0.5);
    }];
    [backview addSubview:lineview3];


    UILabel *lab4 = [[UILabel alloc] init];
    [self customLabel:lab4 text:@"联系地址"];
    [backview addSubview:lab4];
    [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineview3.mas_bottom).offset(17);
        make.left.equalTo(backview.mas_left).offset(12);
        make.height.equalTo(@13);
        make.width.equalTo(@60);
    }];

    UILabel *lab4_value = [[UILabel alloc] init];
    if (isEmpty(self.smodel.address)) {
    [self customLabel:lab4_value text:self.smodel.detailedAddress];
    }else{
    [self customLabel:lab4_value text:self.smodel.address];
    }
    
    [backview addSubview:lab4_value];
    [lab4_value mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lab4.mas_centerY);
        make.left.equalTo(lab4.mas_right).offset(20);
        make.right.equalTo(backview.mas_right).offset(-20);
        make.height.equalTo(@13);
    }];
    
//    UIView *lineview4 = [[UIView alloc] init];
//    lineview4.backgroundColor = [UIColor lightGrayColor];
//    lineview4.alpha = 0.3;
//    [backview addSubview:lineview4];
//    [lineview4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(lab4.mas_bottom).offset(18);
//        make.left.equalTo(lab4_value.mas_left).offset(0);
//        make.right.equalTo(lab4_value.mas_right).offset(0);
//        make.height.mas_equalTo(0.5);
//    }];
//    [backview addSubview:lineview4];
    
    
}


#pragma mark ------------------------Private------------------------------
- (void)customLabel:(UILabel *)lab text:(NSString *)text
{
    lab.textAlignment = NSTextAlignmentLeft;
    lab.font = CUSTOMFONT(14);
    lab.textColor = UIColorFromRGB(0x343434);
    lab.text = text;
}


- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {

    NSDictionary *attrs = @{NSFontAttributeName : font};

    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;

}



@end
