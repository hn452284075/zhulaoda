//
//  PayShowView.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SeleTypeBlock)(NSInteger paytype);

@interface PayShowView : UIView
{
    UIButton *checkBtn;
}
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UIView *typeView;//微信or支付宝View
@property (nonatomic,strong)UIButton *currentPayBtn;
@property (nonatomic,strong)UIButton *wxBtn;
@property (nonatomic,strong)UIButton *zfbBtn;
@property (nonatomic,strong)NSString *details;
@property (nonatomic,copy)SeleTypeBlock seletecdTypeBlock;

-(instancetype)initWithFrame:(CGRect)frame withGoodsPrice:(NSString *)price AndGoodsNum:(NSString *)num;
-(instancetype)initWithFrame:(CGRect)frame withGoodsPrice:(NSString *)price AndGoodsNum:(NSString *)num WithDetails:(NSString *)detail;
@end

