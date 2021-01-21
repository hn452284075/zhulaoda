//
//  ManageStoreCellView.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/4.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "ManageStoreCellView.h"

@implementation ManageStoreCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *iconimg = [UIButton buttonWithType:UIButtonTypeCustom];
        iconimg.tag = 1;
        [self addSubview:iconimg];
        [iconimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(0);
            make.left.equalTo(self.mas_left).offset(15);
            make.width.mas_offset(30);
            make.height.mas_equalTo(30);
        }];
        iconimg.userInteractionEnabled = NO;

        UILabel *msglab = [[UILabel alloc] init];
        msglab.tag = 2;
        [self addSubview:msglab];
        [msglab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(0);
            make.left.equalTo(iconimg.mas_right).offset(15);
            make.width.mas_offset(70);
            make.height.mas_equalTo(15);
        }];
        msglab.textAlignment = NSTextAlignmentLeft;
        msglab.font = CUSTOMFONT(16);
        msglab.textColor = kGetColor(0x22, 0x22, 0x22);

        UIImageView *arrowimg = [[UIImageView alloc] init];
        arrowimg.tag = 4;
        [self addSubview:arrowimg];
        [arrowimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(0);
            make.right.equalTo(self.mas_right).offset(-15);
            make.width.mas_offset(14);
            make.height.mas_equalTo(19);
        }];
        arrowimg.image = IMAGE(@"rightArrow");
        
        
        UILabel *statuslab = [[UILabel alloc] init];
        statuslab.tag = 3;
        [self addSubview:statuslab];
        [statuslab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(0);
            make.right.equalTo(arrowimg.mas_left).offset(-10);
            make.width.mas_offset(170);
            make.height.mas_equalTo(15);
        }];
        statuslab.textAlignment = NSTextAlignmentRight;
        statuslab.font = CUSTOMFONT(16);
        statuslab.textColor = kGetColor(0x9a, 0x9a, 0x9a);
        
    }
    return self;
}

- (void)configCellInfoImage:(NSString *)imagename title:(NSString *)title status:(NSString *)subtitle
{
    UIButton *btn = [self viewWithTag:1];
    [btn setImage:IMAGE(imagename) forState:UIControlStateNormal];
    
    UILabel *lab1 = [self viewWithTag:2];
    lab1.text = title;
    
    UILabel *lab2 = [self viewWithTag:3];
    lab2.text = subtitle;
}


- (void)configCellInfoShowImage:(BOOL)flag1 showTitle:(BOOL)flag2 showSubTitle:(BOOL)flag3 showArrow:(BOOL)flag4
{
    UIButton *btn = [self viewWithTag:1];
    btn.hidden = !flag1;
    
    UILabel *lab1 = [self viewWithTag:2];
    lab1.hidden = !flag2;
    
    UILabel *lab2 = [self viewWithTag:3];
    lab2.hidden = !flag3;
}

@end
