//
//  PDBottumInfoView.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "PDBottumInfoView.h"

@implementation PDBottumInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)configViewText1:(NSString *)str1 text2:(NSString *)str2
{
    self.msLabel.text = str1;
    self.pwLabel.text = str2;
    [self configView];    
}


- (void)configView
{
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.backView.layer.shadowRadius  = 2;
    self.backView.layer.shadowOffset  = CGSizeMake(0.0f,6.0f);
    self.backView.layer.shadowOpacity = 0.3f;
    self.backView.layer.cornerRadius  = 5.;
}


@end
