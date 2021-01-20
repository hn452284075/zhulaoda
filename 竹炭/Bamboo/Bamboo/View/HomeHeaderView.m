//
//  HomeHeaderView.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/25.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "HomeHeaderView.h"
#import "UIImage+extern.h"
@implementation HomeHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    //创建 layer圆角化上左 上右
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
      maskLayer.frame = self.typeBgView.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: self.typeBgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
    maskLayer.frame = self.typeBgView.bounds;
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.typeBgView.layer.mask = maskLayer;
    
    
    //创建 layer圆角化上左 上右
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
      maskLayer.frame = self.typeBgView2.bounds;
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect: self.typeBgView2.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5,5)];
    maskLayer2.frame = self.typeBgView2.bounds;
    //赋值
    maskLayer2.path = maskPath2.CGPath;
    self.typeBgView2.layer.mask = maskLayer2;

    
}
- (void)setArray:(NSArray *)array{
    
    _headCycleView.currentPageDotImage= IMAGE(@"圆角");
    _headCycleView.pageDotImage=[UIImage imageWithColor:[UIColor whiteColor] size:CGSizeMake(6, 6)];
    _headCycleView.imageURLStringsGroup = array;
//    _headCycleView.placeholderImage=IMAGE(@"");


}


- (IBAction)seletecdBtnClick:(UIButton *)sender {
    emptyBlock(self.seletecdIndexBlock,sender.tag);
}

@end
