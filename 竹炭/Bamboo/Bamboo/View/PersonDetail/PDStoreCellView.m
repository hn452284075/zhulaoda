//
//  PDStoreCellView.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "PDStoreCellView.h"

@interface PDStoreCellView()

@property (nonatomic, strong) NSArray *tempTagArray;

@end

@implementation PDStoreCellView
@synthesize delegate;


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title vaule1Str:(NSString *)value1 value2Str:(NSString *)value2 value3Str:(NSString *)value3 tagArray:(NSArray *)arr showFlag:(BOOL)flag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.nameLabel = [[UILabel alloc] init];
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(15);
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right);
            make.height.mas_equalTo(15);
        }];
        self.nameLabel.text = title;//@"邓彦忠合作社";
        self.nameLabel.font = [UIFont boldSystemFontOfSize:14];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.textColor = UIColorFromRGB(0x111111);
        
        
        self.msgLabl_1 = [[UILabel alloc] init];
        [self addSubview:self.msgLabl_1];
        [self.msgLabl_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.left.equalTo(self.mas_left).offset(15);
            make.width.mas_equalTo((kScreenWidth-30)/3);
            make.height.mas_equalTo(15);
        }];
        self.msgLabl_1.text = value1;//@"持续经营:88天";
        self.msgLabl_1.font = CUSTOMFONT(12);
        self.msgLabl_1.textAlignment = NSTextAlignmentLeft;
        self.msgLabl_1.textColor = UIColorFromRGB(0x666666);
        
        
        self.msgLabl_2 = [[UILabel alloc] init];
        [self addSubview:self.msgLabl_2];
        [self.msgLabl_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.centerX.equalTo(self.mas_centerX).offset(0);
            make.width.mas_equalTo((kScreenWidth-30)/3);
            make.height.mas_equalTo(15);
        }];
        self.msgLabl_2.text = value2;//@"累计交易:66万元";
        self.msgLabl_2.font = CUSTOMFONT(12);
        self.msgLabl_2.textAlignment = NSTextAlignmentCenter;
        self.msgLabl_2.textColor = UIColorFromRGB(0x666666);
        
        self.msgLabl_3 = [[UILabel alloc] init];
        [self addSubview:self.msgLabl_3];
        [self.msgLabl_3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
            make.right.equalTo(self.mas_right).offset(-15);
            make.width.mas_equalTo((kScreenWidth-30)/3);
            make.height.mas_equalTo(15);
        }];
        self.msgLabl_3.text = value3;//@"订单笔数:30单";
        self.msgLabl_3.font = CUSTOMFONT(12);
        self.msgLabl_3.textAlignment = NSTextAlignmentRight;
        self.msgLabl_3.textColor = UIColorFromRGB(0x666666);
        
        self.tempTagArray = arr;
        
        NSString *tag1str;
        NSString *tag2str;
        NSString *tag3str;
        int d_h = 20;
        if(arr.count > 0)
        {
            tag1str = [arr objectAtIndex:0];
            int len1 = [self sizeWithText:tag1str font:CUSTOMFONT(12) maxSize:CGSizeMake(100, 20)].width;
            self.defaultBtn_1 = [[UIButton alloc] init];
            [self addSubview:self.defaultBtn_1];
            [self.defaultBtn_1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.self.msgLabl_3.mas_bottom).offset(20);
                make.left.equalTo(self.mas_left).offset(15);
                make.width.mas_equalTo(len1+d_h);
                make.height.mas_equalTo(30);
            }];
            [self factory_btn:self.defaultBtn_1 backColor:[UIColor whiteColor] textColor:UIColorFromRGB(0x222222) borderColor:UIColorFromRGB(0xeaeaea) title:tag1str fontsize:12 corner:5 tag:10];
        }
        if(arr.count > 1)
        {
            tag2str = [arr objectAtIndex:1];
            int len2 = [self sizeWithText:tag2str font:CUSTOMFONT(12) maxSize:CGSizeMake(100, 20)].width;
            self.defaultBtn_2 = [[UIButton alloc] init];
            [self addSubview:self.defaultBtn_2];
            [self.defaultBtn_2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.defaultBtn_1.mas_top).offset(0);
                make.left.equalTo(self.defaultBtn_1.mas_right).offset(12);
                make.width.mas_equalTo(len2+d_h);
                make.height.mas_equalTo(30);
            }];
            [self factory_btn:self.defaultBtn_2 backColor:[UIColor whiteColor] textColor:UIColorFromRGB(0x222222) borderColor:UIColorFromRGB(0xeaeaea) title:tag2str fontsize:12 corner:5 tag:11];
        }
        if(arr.count > 2)
        {
            tag3str = [arr objectAtIndex:2];
            int len3 = [self sizeWithText:tag3str font:CUSTOMFONT(12) maxSize:CGSizeMake(100, 20)].width;
            self.defaultBtn_3 = [[UIButton alloc] init];
            [self addSubview:self.defaultBtn_3];
            [self.defaultBtn_3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.defaultBtn_1.mas_top).offset(0);
                make.left.equalTo(self.defaultBtn_2.mas_right).offset(12);
                make.width.mas_equalTo(len3+d_h);
                make.height.mas_equalTo(30);
            }];
            [self factory_btn:self.defaultBtn_3 backColor:[UIColor whiteColor] textColor:UIColorFromRGB(0x222222) borderColor:UIColorFromRGB(0xeaeaea) title:tag3str fontsize:12 corner:5 tag:12];
        }
        
        if(arr.count > 3)
        {
            //当数组大于3的时候，显示更多按钮
            self.moreBtn = [[UIButton alloc] init];
            [self addSubview:self.moreBtn];
            [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.defaultBtn_1.mas_top).offset(0);
                make.right.equalTo(self.mas_right).offset(-15);
                make.width.mas_equalTo(50);
                make.height.mas_equalTo(30);
            }];
            [self factory_btn:self.moreBtn backColor:[UIColor whiteColor] textColor:UIColorFromRGB(0x46C67B) borderColor:UIColorFromRGB(0x46C67B) title:@"更多" fontsize:12 corner:5 tag:100];
            
            if(flag == YES)
            {
                [self.moreBtn setTitle:@"收起" forState:UIControlStateNormal];
                
                int x = 15;
                int y = 120;
                for(int i=3;i<arr.count;i++)
                {
                    UIButton *tagbtn = [[UIButton alloc] init];
                    [self factory_btn:tagbtn backColor:[UIColor whiteColor] textColor:UIColorFromRGB(0x222222) borderColor:UIColorFromRGB(0xeaeaea) title:[arr objectAtIndex:i] fontsize:12 corner:5 tag:13+i];
                                    
                    [self addSubview:tagbtn];

                    CGSize ze = [self sizeWithText:[arr objectAtIndex:i] font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(200, 31)];

                    if(x + ze.width + 30 > kScreenWidth)  //超过屏幕宽度，另起i一行
                    {
                        x = 15;
                        y = y + 31 + 15;
                    }

                    tagbtn.frame = CGRectMake(x, y, ze.width+20, 30);
                    x +=35;
                    x +=ze.width;

                    if(i == 0)
                    {
                        [tagbtn sendActionsForControlEvents:UIControlEventTouchUpInside];
                    }
                }
            }
        }
    }
    return self;
}


- (void)factory_btn:(UIButton *)btn backColor:(UIColor *)bcolor textColor:(UIColor *)tcolor borderColor:(UIColor *)dcolor title:(NSString *)title fontsize:(int)fsize corner:(float)csize
                tag:(int)tag;
{
    btn.backgroundColor = bcolor;
    btn.layer.borderColor = dcolor.CGColor;
    [btn setTitleColor:tcolor forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.;
    btn.layer.cornerRadius = csize;
    btn.titleLabel.font = CUSTOMFONT(fsize);
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
}

- (void)btnClicked:(UIButton *)sender
{
    if(sender.tag == 100)
    {
        int x = 15;
        int y = 120+ 31 + 15;
        for(int i=3;i<self.tempTagArray.count;i++)
        {
            CGSize ze = [self sizeWithText:[self.tempTagArray objectAtIndex:i] font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(200, 31)];
            if(x + ze.width + 30 > kScreenWidth)  //超过屏幕宽度，另起i一行
            {
                x = 15;
                y = y + 31 + 15;
            }
            x += 35;
            x += ze.width;
        }
        
        if([sender.titleLabel.text isEqualToString:@"更多"])
        {
            [self.delegate PDCellViewChangeShowStatus:y];
        }
        else if([sender.titleLabel.text isEqualToString:@"收起"])
        {
            [self.delegate PDCellViewChangeShowStatus:120];
        }
    }
    else
    {
        for(UIView *v in self.subviews)
        {
            if([v isKindOfClass:[UIButton class]] && v.tag!= 100 && v.tag != 101)
            {
                UIButton *btn = (UIButton *)v;
                btn.layer.borderWidth = 1;
                btn.layer.borderColor = UIColorFromRGB(0xeaeaea).CGColor;
                [btn setTitleColor:kGetColor(0x22, 0x22, 0x22) forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor clearColor];
            }
        }
        
        UIButton *btn = (UIButton *)sender;
        btn.layer.borderColor = kGetColor(0x47, 0xc6, 0x7c).CGColor;
        [btn setTitleColor:kGetColor(0x47, 0xc6, 0x7c) forState:UIControlStateNormal];
        btn.layer.borderWidth = 1.;
        btn.backgroundColor = [UIColor clearColor];
        
        [self.delegate PDCellViewClickedItem:btn.titleLabel.text];
    }
}



- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {

    NSDictionary *attrs = @{NSFontAttributeName : font};

    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;

}


@end
