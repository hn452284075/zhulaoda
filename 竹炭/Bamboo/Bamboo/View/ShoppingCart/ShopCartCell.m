//
//  ShopCartCell.m
//  ZuziFresh_ios
//
//  Created by 曾勇兵 on 2017/7/25.
//  Copyright © 2017年 zengyongbing. All rights reserved.
//

#import "ShopCartCell.h"
#import "GoodsModel.h"
#import "UIImageView+sd_SetImg.h"
@implementation ShopCartCell

- (void)awakeFromNib {
    [super awakeFromNib];

//    UIView *view = [[UIView alloc] initWithFrame:self.multipleSelectionBackgroundView.bounds];
//    view.backgroundColor = [UIColor whiteColor];
//    self.selectedBackgroundView = view;
//    
 
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.editing) {
        if (selected) {
            // 取消多选时cell成蓝色
            //            self.contentView.backgroundColor = [UIColor whiteColor];
            //            self.backgroundView.backgroundColor = [UIColor whiteColor];
            
        }else{
            
        }
    }

    // Configure the view for the selected state
}
- (IBAction)seletedClick:(UIButton *)sender {

    sender.selected = !sender.selected;
    if (!_isCart) {
        self.model.selected =sender.selected;
    }
    emptyBlock(self.seletedBlock,self);
}


//以下两个方法之所以重写 ，收藏页使用到
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    if (editing) {
        for (UIControl *control in self.subviews){
            if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
                for (UIView *v in control.subviews)
                {
                    if ([v isKindOfClass: [UIImageView class]]) {
                        UIImageView *img=(UIImageView *)v;
                        CGRect rect = img.frame;
                        rect.size.height = rect.size.width = 15;
                        img.frame = rect;
                        
                        img.image = [UIImage imageNamed:@"未选中状态"];
                    }
                }
            }
        }
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //    self.selected = NO;
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    CGRect rect = img.frame;
                    rect.size.height = rect.size.width = 15;
                    img.frame = rect;
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"选中状态"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"未选中状态"];
                    }
                }
            }
        }
    }
    
}






- (void)setModel:(GoodsModel *)model{
    _model=model;
    [_goodsImage sd_SetImgWithUrlStr:model.goodsThumb placeHolderImgName:@"首页列表产品加载缩略图"];
    
    _seletecdBtn.selected = model.selected;
    _goodsName.text = model.goodsName;
    _specLabel.text=[NSString stringWithFormat:@"%@%@起批",model.quantity,model.unit];
    [_specBtn setTitle:model.specName forState:UIControlStateNormal];
    _addSubtractButton.textField.text = [NSString stringWithFormat:@"%d",[model.goodsNumber intValue]];
    _price.text = [NSString stringWithFormat:@"%@",model.unitPrice];
    
    _unitLabel.text = [NSString stringWithFormat:@"/%@",model.unit];
    _addSubtractButton.smallResult=[model.quantity intValue];
    WEAK_SELF
    if (_addSubtractButton.textField.text.length>4) {
        [weak_self changeLayout];
    }
   

    
    _addSubtractButton.callBack = ^(NSInteger currentNum){
        
        if (currentNum+1>[model.quantity intValue]) {
        
        weak_self.goodsNumBlock(weak_self,@(currentNum));
        }else{
           weak_self.addSubtractButton.textField.text = [NSString stringWithFormat:@"%d",[model.goodsNumber intValue]];
        }
        [weak_self changeLayout];
    };
    
    _addSubtractButton.fieldBack = ^(NSInteger currentNum) {
        [weak_self changeLayout];
    };
    
    
#pragma mark - MODIFY
    if (!model.isValid) {
        if (model.isEditing) {
            self.seletecdBtn.enabled = YES;
            self.seletecdBtn.selected = model.selected;
        }else {
            self.seletecdBtn.enabled = NO;
            self.seletecdBtn.selected = NO;
        }
    }else {
        self.seletecdBtn.enabled = YES;
    }
    
    
}


-(void)changeLayout{

    //改变数量输入框的宽度
    if (_addSubtractButton.textField.text.length==5) {
        if (self.addSubViewWidth.constant!=93) {
         self.addSubViewWidth.constant=93;
        }
         
    }else if (_addSubtractButton.textField.text.length==6) {
          if (self.addSubViewWidth.constant!=100) {
                 self.addSubViewWidth.constant=100;
          }
    }else if (_addSubtractButton.textField.text.length==7) {
          if (self.addSubViewWidth.constant!=110) {
                 self.addSubViewWidth.constant=110;
          }
    }else{
        //如果之前长度大于4 现在长度小了就还原
        if (self.addSubViewWidth.constant>83) {
          self.addSubViewWidth.constant=83;
        }
    }
 
}




@end
