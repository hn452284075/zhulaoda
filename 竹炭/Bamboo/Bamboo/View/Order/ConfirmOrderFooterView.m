//
//  ConfirmOrderFooterView.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "ConfirmOrderFooterView.h"

@implementation ConfirmOrderFooterView

-(void)awakeFromNib{
    [super awakeFromNib];
    //创建 layer
      CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, kScreenWidth-28, self.frame.size.height);
      UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: maskLayer.frame = CGRectMake(0, 0, kScreenWidth-28, self.frame.size.height) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
      maskLayer.frame = CGRectMake(0, 0, kScreenWidth-28, self.frame.size.height);
      //赋值
      maskLayer.path = maskPath.CGPath;
      self.layer.mask = maskLayer;
    
    self.noteField.delegate = self;
}

- (void)setModel:(StoreModel *)model{
    _model=model;
    
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[self reviseString: model.subTotal]];
    self.noteField.text =model.note;//订单备注
}
-(NSString *)reviseString:(NSString *)str
{
 //直接传入精度丢失有问题的Double类型
 double conversionValue = [str doubleValue];
 NSString *doubleString = [NSString stringWithFormat:@"%lf", conversionValue];
 NSDecimalNumber *decNumber = [NSDecimalNumber decimalNumberWithString:doubleString];
 return [decNumber stringValue];
}

//文本输入框结束输入时调用//订单备注
- (void)textFieldDidEndEditing:(UITextField *)textField{

   
    _model.note=textField.text;
    

}
@end
