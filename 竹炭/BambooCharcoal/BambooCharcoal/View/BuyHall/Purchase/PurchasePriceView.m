//
//  PurchasePriceView.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/28.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "PurchasePriceView.h"

@interface PurchasePriceView()

@property (nonatomic, assign) BOOL isopen;

@end

@implementation PurchasePriceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)congfigView
{
    self.isopen = YES;
    
    self.textfiledBackview.backgroundColor = [UIColor whiteColor];
    self.detailTextview.text = @"";
    self.detailTextview.layer.cornerRadius   = 5.;
    self.detailTextview.layer.borderColor    = UIColorFromRGB(0x9a9a9a).CGColor;
    self.detailTextview.layer.borderWidth    = .5;
    self.camareNumberLab.layer.cornerRadius  = 6.5;
    self.camareNumberLab.layer.masksToBounds = YES;
    self.camareNumberLab.backgroundColor = UIColorFromRGB(0xFF2B01);
    self.camareNumberLab.textColor = [UIColor whiteColor];
    self.submitBtn.layer.cornerRadius  = 5.;
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.backgroundColor = UIColorFromRGB(0x46C67C);
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.priceTextfiled.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self.priceTextfiled addTarget:self action:@selector(beginEdit) forControlEvents:UIControlEventTouchDown];
}

- (void)beginEdit
{
    [self.delegate textfiledEdit_action];
}


- (IBAction)moreBtnClicked:(id)sender
{
    [self.delegate more_action];
}

- (IBAction)checkBtnClicked:(id)sender
{
    if(self.isopen == YES)
    {
        [self.checkBtn setImage:[UIImage imageNamed:@"storeunselectedicon"] forState:UIControlStateNormal];
    }
    else
    {
        [self.checkBtn setImage:[UIImage imageNamed:@"storeselectedicon"] forState:UIControlStateNormal];
    }
    self.isopen = !self.isopen;
}

- (IBAction)cartBtnClicked:(id)sender
{
    [self.delegate cart_action];
}

- (IBAction)camareBtnClicked:(id)sender
{
    [self.delegate camare_action];
}

- (IBAction)submitBtnClicked:(id)sender {

    [self.delegate submit_action:self.isopen
                           price:self.priceTextfiled.text
                      detailInfo:self.detailTextview.text];
}
@end
