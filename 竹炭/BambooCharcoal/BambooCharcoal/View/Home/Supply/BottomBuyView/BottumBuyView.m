//
//  BottumBuyView.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/8/28.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BottumBuyView.h"
#import "UIView+BlockGesture.h"
@implementation BottumBuyView
@synthesize delegate;


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
         self.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
         self.layer.shadowOpacity = 0.2;//阴影透明度，默认0
         self.layer.masksToBounds = NO;
        
        int size = 23;
        int x = 25;
        int gap = (kScreenWidth/2-x*2-size*3)/2-12;
        
        UIImageView *chatImg = [[UIImageView alloc] initWithFrame:CGRectMake(x, 10, size-20, size-20)];
        chatImg.image = IMAGE(@"supply_chat");
        WEAK_SELF
        chatImg.userInteractionEnabled=YES;
        [chatImg addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            //[weak_self callBtnClicked];
        }];
        [self addSubview:chatImg];
        chatImg.hidden = YES;
        
//        UIImageView *callImg = [[UIImageView alloc] initWithFrame:CGRectMake(x+size+gap, 10, size, size)];
        UIImageView *callImg = [[UIImageView alloc] initWithFrame:CGRectMake(x+size/3+gap/3, 10, size, size)];
        callImg.userInteractionEnabled=YES;
        [callImg addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self chatBtnClicked];
        }];
        callImg.image = IMAGE(@"supply_call");
        [self addSubview:callImg];
        
        UIImageView *carImg = [[UIImageView alloc] initWithFrame:CGRectMake(x+1.7*(size+gap), 10, size, size)];
        carImg.userInteractionEnabled=YES;
        carImg.image = IMAGE(@"supply_car");
        [carImg addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self carBtnClicked];
        }];
        [self addSubview:carImg];
        
        UIButton *chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size*2, size*1.5)];
        [self addSubview:chatBtn];
        [chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(chatImg.mas_centerX);
            make.top.equalTo(chatImg.mas_bottom).offset(-6);
        }];
        //[chatBtn setTitle:@"聊一聊" forState:UIControlStateNormal];
        [chatBtn setTitle:@" " forState:UIControlStateNormal];
        chatBtn.titleLabel.font = CUSTOMFONT(12);
        [chatBtn setTitleColor:kGetColor(0x9a, 0x9a, 0x9a) forState:UIControlStateNormal];
        [chatBtn addTarget:self action:@selector(chatBtnClicked) forControlEvents:UIControlEventTouchUpInside];
       
        
        UIButton *callBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size*2, size*1.5)];
        [self addSubview:callBtn];
        [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(callImg.mas_centerX);
            make.top.equalTo(callImg.mas_bottom).offset(-6);
        }];
        [callBtn setTitle:@"打电话" forState:UIControlStateNormal];
        callBtn.titleLabel.font = CUSTOMFONT(12);
        [callBtn setTitleColor:kGetColor(0x9a, 0x9a, 0x9a) forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(callBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        UIButton *carBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size*2, size*1.5)];
        [self addSubview:carBtn];
        [carBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(carImg.mas_centerX);
            make.top.equalTo(carImg.mas_bottom).offset(-6);
        }];
        [carBtn setTitle:@"购物车" forState:UIControlStateNormal];
        carBtn.titleLabel.font = CUSTOMFONT(12);
        [carBtn setTitleColor:kGetColor(0x9a, 0x9a, 0x9a) forState:UIControlStateNormal];
        [carBtn addTarget:self action:@selector(carBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        
        carSubBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        carSubBtn.hidden=YES;
        [self addSubview:carSubBtn];
        [carSubBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(carImg.mas_left).offset(13);
            make.top.equalTo(carImg.mas_top).offset(-4);
            make.width.mas_equalTo(14);
            make.height.mas_equalTo(14);
        }];
        
        carSubBtn.titleLabel.font = CUSTOMFONT(9);
        [carSubBtn setTitleColor:kGetColor(0xff, 0xff, 0xff) forState:UIControlStateNormal];
        carSubBtn.backgroundColor = kGetColor(0xff, 0x48, 0x06);
        carSubBtn.layer.cornerRadius = 7;
        
        UIButton *buyBtn = [[UIButton alloc] init];
        [self addSubview:buyBtn];
        [buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.top.equalTo(self.mas_top).offset(8);
            make.height.mas_equalTo(42);
            make.width.mas_equalTo((kScreenWidth-15*3-size*3-gap*2)/2-8);
        }];
        [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        buyBtn.titleLabel.font = CUSTOMFONT(16);
        [buyBtn setTitleColor:kGetColor(0xff, 0xff, 0xff) forState:UIControlStateNormal];
        buyBtn.backgroundColor = kGetColor(61, 190, 104);
        [buyBtn addTarget:self action:@selector(buyBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *addBtn = [[UIButton alloc] init];
        [self addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(buyBtn.mas_left).offset(0);
            make.top.equalTo(self.mas_top).offset(8);
            make.height.mas_equalTo(42);
            make.width.mas_equalTo((kScreenWidth-15*3-size*3-gap*2)/2);
        }];
        [addBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        addBtn.titleLabel.font = CUSTOMFONT(16);
        [addBtn setTitleColor:kGetColor(0xff, 0xff, 0xff) forState:UIControlStateNormal];
        addBtn.backgroundColor = kGetColor(254, 165, 10);
        [addBtn addTarget:self action:@selector(addBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:buyBtn.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
            CAShapeLayer *maskLayer=[[CAShapeLayer alloc]init];
            maskLayer.frame=buyBtn.bounds;
            maskLayer.path=maskPath.CGPath;
            buyBtn.layer.mask=maskLayer;
        });
        
         dispatch_async(dispatch_get_main_queue(), ^{
            UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:addBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
            CAShapeLayer *maskLayer=[[CAShapeLayer alloc]init];
            maskLayer.frame=addBtn.bounds;
            maskLayer.path=maskPath.CGPath;
            addBtn.layer.mask=maskLayer;
        });
        
        
    }
    return self;
}

- (void)setCartNum:(NSString *)cartNum{
    if ([cartNum intValue]==0) {
        carSubBtn.hidden=YES;
    }else{
        carSubBtn.hidden=NO;
        [carSubBtn setTitle:cartNum forState:UIControlStateNormal];
    }
    
}

- (void)chatBtnClicked
{
    [self.delegate chat_action];
}

- (void)callBtnClicked
{
    [self.delegate call_action];
}

- (void)carBtnClicked
{
    [self.delegate cart_action];
}

- (void)addBtnClicked:(id)sender
{
    [self.delegate addToCart_action];
}

- (void)buyBtnClicked:(id)sender
{
    [self.delegate buy_action];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
