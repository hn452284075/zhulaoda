//
//  PDHeadInfoView.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "PDHeadInfoView.h"

@implementation PDHeadInfoView

- (void)configViewData:(PersonDetailModel *)model
{
    [self configView];
    
    [self.headimg sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:IMAGE(@"my-header")]; //IMAGE(model.headImg);
    self.namelabel.text     = model.name;
    self.numberLabel_1.text = model.fansNumber;
    self.numberLabel_2.text = model.visitorNumber;
    self.numberLabel_3.text = model.chatNumber;
    self.adressLabel.text   = model.adressString;
    
    if(model.tagFlag == 0)
    {
        self.starImg.hidden = YES;
        self.subNameLabel.hidden = YES;
    }
    
}


- (void)configView
{
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.backView.layer.shadowRadius  = 13;
    self.backView.layer.shadowOffset  = CGSizeMake(0.0f,0.0f);
    self.backView.layer.shadowOpacity = 0.5f;
    self.backView.layer.cornerRadius  = 5.;

    self.headimg.layer.cornerRadius = self.headimg.frame.size.height/2;
    
    
    [self.attentionBtn setTitle:@" 关注" forState:UIControlStateNormal];
    [self.attentionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.attentionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 6)];
    self.attentionBtn.titleLabel.font= CUSTOMFONT(11);
    self.attentionBtn.layer.cornerRadius = 9.5;
    self.attentionBtn.backgroundColor = UIColorFromRGB(0x46C67C);
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
