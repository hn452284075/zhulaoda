//
//  UnitView.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/1.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "UnitView.h"

@interface UnitView()

@property (nonatomic, assign) int selectedIndex;

@end

@implementation UnitView
@synthesize delegate;

- (instancetype)initWithFrame:(CGRect)frame title:(nonnull NSString *)title tagArr:(nonnull NSArray *)tagArr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.array=tagArr;
        int iphonex_height = 0;
        if(IS_Iphonex_Series)
            iphonex_height = 20;
        
        UIView *bgv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        bgv.backgroundColor = [UIColor lightGrayColor];        
        bgv.alpha = 0.5;
        [self addSubview:bgv];
        
        UITapGestureRecognizer *tapgesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBgview:)];
        tapgesture.delegate = self;
        [bgv addGestureRecognizer:tapgesture];
        
        
        UIView *whiteView = [[UIView alloc] init];
        [self addSubview:whiteView];
        whiteView.backgroundColor = [UIColor whiteColor];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_equalTo(350+iphonex_height);
        }];
        
        UILabel *msglab = [[UILabel alloc] init];
        [self addSubview:msglab];
        [msglab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(whiteView.mas_top).offset(25);
            make.left.equalTo(self.mas_left).offset(20);
            make.right.equalTo(self.mas_right).offset(-20);
            make.height.mas_equalTo(16);
        }];
        if(title.length > 0)
        {
            msglab.text = title;
            msglab.font = CUSTOMFONT(16);
            msglab.textColor = UIColorFromRGB(0x222222);
            msglab.textAlignment = NSTextAlignmentCenter;
        }
        else
        {
            NSString *aStr = @"请从下方选择计量单位 (只能选择一个)";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",aStr]];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0,10)];
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(10,str.length-10)];
            [str addAttribute:NSForegroundColorAttributeName value:kGetColor(0x22, 0x22, 0x22) range:NSMakeRange(0,str.length)];
            [msglab setAttributedText:str];
            msglab.textAlignment = NSTextAlignmentLeft;
        }
        
        
        
//        UIButton *okBtn = [[UIButton alloc] init];
//        [self addSubview:okBtn];
//        [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.mas_bottom).offset(-15-iphonex_height);
//            make.left.equalTo(self.mas_left).offset(54);
//            make.right.equalTo(self.mas_right).offset(-54);
//            make.height.mas_equalTo(40);
//        }];
//        [okBtn setTitle:@"确定" forState:UIControlStateNormal];
//        okBtn.titleLabel.font = CUSTOMFONT(16);
//        okBtn.layer.cornerRadius = 20;
//        okBtn.layer.masksToBounds = YES;
//        [okBtn setTitleColor:kGetColor(0xff, 0xff, 0xff) forState:UIControlStateNormal];
//        [okBtn setBackgroundColor:kGetColor(0x46, 0xc6, 0x7b)];
//        [okBtn addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *okBtn = [[UIButton alloc] init];
        [self addSubview:okBtn];
        [okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-35);
            make.left.equalTo(self.mas_left).offset(BtnLeftRightGap);
            make.right.equalTo(self.mas_right).offset(-BtnLeftRightGap);
            make.height.mas_equalTo(45);
        }];
        [self factory_btn:okBtn
               backColor:KCOLOR_Main
               textColor:[UIColor whiteColor]
             borderColor:KCOLOR_Main
                   title:@"确定"
                fontsize:18
                  corner:22
                     tag:2];
        
        
        
        UIScrollView *scrollv = [[UIScrollView alloc] init];
        scrollv.tag = 100;
        [self addSubview:scrollv];
        [scrollv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(msglab.mas_bottom).offset(15);
            make.bottom.equalTo(okBtn.mas_top).offset(-15);
            make.left.equalTo(self.mas_left).offset(0);
            make.right.equalTo(self.mas_right).offset(-0);
        }];
        
        int x = 15;
        int y = 15;
        for(int i=0;i<tagArr.count;i++)
        {
            UIButton *tagbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tagbtn.backgroundColor = kGetColor(0xf5, 0xf5, 0xf5);
            [tagbtn setTitle:[tagArr objectAtIndex:i]  forState:UIControlStateNormal];
            [scrollv addSubview:tagbtn];
            
            [tagbtn setTitleColor:kGetColor(0x22, 0x22, 0x22) forState:UIControlStateNormal];
            tagbtn.layer.cornerRadius = 3.0;
            tagbtn.tag = 10+i;
            
            CGSize ze = [self sizeWithText:[tagArr objectAtIndex:i] font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(200, 31)];
            
            if(x + ze.width + 30 > kScreenWidth)  //超过屏幕宽度，另起i一行
            {
                x = 15;
                y = y + 31 + 15;
            }
            
            tagbtn.frame = CGRectMake(x, y, ze.width+20, 31);
            tagbtn.titleLabel.font = [UIFont systemFontOfSize:12];
            x +=45;
            x +=ze.width;
            
            [tagbtn addTarget:self action:@selector(tagBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            if(i == 0)
            {
                [tagbtn sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
        scrollv.contentSize = CGSizeMake(kScreenWidth, y+45);
        
    }
    return self;
}

- (void)okBtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(confirmInfo:)]) {
    [self.delegate confirmInfo:self.selectedIndex];
    }
    emptyBlock(self.seletecdStrBlock,self.array[self.selectedIndex]);
    self.delegate = nil;
    [self removeFromSuperview];
}


#pragma mark ------------------------Private------------------------------
- (void)factory_btn:(UIButton *)btn backColor:(UIColor *)bcolor textColor:(UIColor *)tcolor borderColor:(UIColor *)dcolor title:(NSString *)title fontsize:(int)fsize corner:(float)csize
                tag:(int)tag;
{
    btn.backgroundColor = bcolor;
    btn.layer.borderColor = dcolor.CGColor;
    [btn setTitleColor:tcolor forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.;
    btn.layer.cornerRadius = csize;
    btn.titleLabel.font = CUSTOMFONT(fsize);
    [btn addTarget:self action:@selector(okBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
}


- (void)tagBtnClicked:(id)sender
{
    UIScrollView *sc = (UIScrollView *)[self viewWithTag:100];
    
    for(UIView *v in sc.subviews)
    {
        if([v isKindOfClass:[UIButton class]] && v.tag!= 100 && v.tag != 101)
        {
            UIButton *btn = (UIButton *)v;
            btn.layer.borderWidth = 0;
            [btn setTitleColor:kGetColor(0x22, 0x22, 0x22) forState:UIControlStateNormal];
            btn.backgroundColor = kGetColor(0xf5, 0xf5, 0xf5);
        }
    }
    
    UIButton *btn = (UIButton *)sender;
    btn.layer.borderColor = kGetColor(0x47, 0xc6, 0x7c).CGColor;
    [btn setTitleColor:kGetColor(0x47, 0xc6, 0x7c) forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.;
    btn.backgroundColor = [UIColor clearColor];
    self.selectedIndex = (int)btn.tag - 10;
}


- (void)setDefaultSelected:(NSString *)str
{
    UIScrollView *sc = (UIScrollView *)[self viewWithTag:100];
    
    for(UIView *v in sc.subviews)
    {
        if([v isKindOfClass:[UIButton class]] && v.tag!= 100 && v.tag != 101)
        {
            UIButton *btn = (UIButton *)v;
            btn.layer.borderWidth = 0;
            [btn setTitleColor:kGetColor(0x22, 0x22, 0x22) forState:UIControlStateNormal];
            btn.backgroundColor = kGetColor(0xf5, 0xf5, 0xf5);
        }
    }
    
    for(UIView *v in sc.subviews)
    {
        if([v isKindOfClass:[UIButton class]] && v.tag!= 100 && v.tag != 101)
        {
            UIButton *btn = (UIButton *)v;
            if([btn.titleLabel.text isEqualToString:str])
            {
                btn.layer.borderColor = kGetColor(0x47, 0xc6, 0x7c).CGColor;
                [btn setTitleColor:kGetColor(0x47, 0xc6, 0x7c) forState:UIControlStateNormal];
                btn.layer.borderWidth = 1.;
                btn.backgroundColor = [UIColor clearColor];
                self.selectedIndex = (int)btn.tag - 10;
                break;
            }
        }
    }
    
}
    



- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {

    NSDictionary *attrs = @{NSFontAttributeName : font};

    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;

}



- (void)dismissBgview:(id)sender
{
   
    emptyBlock(self.seletecdStrBlock,@"");
     self.delegate = nil;
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
