//
//  ShopInfoView.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/8/28.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "ShopInfoView.h"

@implementation ShopInfoView
@synthesize delegate;


- (void)_initShopInfoWithInfo:(NSString *)shopimg shopname:(NSString *)name shopgrade:(NSString *)grade grade_1:(NSString *)grade_1 grade_2:(NSString *)grade_2 grade_3:(NSString *)grade_3 tagArr:(NSArray *)tagarr
{
    UIImageView *headimg = [self viewWithTag:1];
    [headimg sd_SetImgWithUrlStr:shopimg placeHolderImgName:@"login_logo"];
    
    UILabel *namelab = [self viewWithTag:2];
    namelab.text = name;
    namelab.font = [UIFont boldSystemFontOfSize:14];
    
    UILabel *gradelab = [self viewWithTag:3];
    gradelab.text = grade;
    
    UILabel *grade_1_lab = [self viewWithTag:5];
    grade_1_lab.text = grade_1;
    
    UILabel *grade_2_lab = [self viewWithTag:7];
    grade_2_lab.text = grade_2;
    
    UILabel *grade_3_lab = [self viewWithTag:9];
    grade_3_lab.text = grade_3;
    
    int x = 12;  //@"牛商",@"企",@"店铺",@"实力",
    for(int i=0;i<tagarr.count;i++)
    {
        UIButton *tagbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if(i == 0)
            tagbtn.backgroundColor = kGetColor(0xff, 0x27, 0x0a);
        if(i == 1)
            tagbtn.backgroundColor = kGetColor(0x03, 0xc3, 0xd9);
        if(i == 2)
            tagbtn.backgroundColor = kGetColor(0xf9, 0x59, 0x58);
        if(i == 3)
        tagbtn.backgroundColor = UIColorFromRGB(0x03C39D);
        
        [tagbtn setTitle:[tagarr objectAtIndex:i]  forState:UIControlStateNormal];
        [self addSubview:tagbtn];
        CGSize ze = [self sizeWithText:[tagarr objectAtIndex:i] font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(200, 16)];
        tagbtn.frame = CGRectMake(x, 116, ze.width+10, 20);
        tagbtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [tagbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        x +=18;
        x +=ze.width;
    }
    
}


- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {

    NSDictionary *attrs = @{NSFontAttributeName : font};

    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;

}


- (IBAction)showShopBtnClicked:(id)sender
{
    [self.delegate enterShopController];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
