//
//  BuyHallInfoHeaderView.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/8.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BuyHallInfoHeaderView.h"
#import "MYLabel.h"

@implementation BuyHallInfoHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame infoModel:(BuyHallInfoModel *)model
{
    self = [super initWithFrame:frame];
    if (self)
    {
        float area_h = [self calcLabHeight:model.info_addr_get fontSize:14 maxWidth:kScreenWidth-65-15*4-5];
        
        
        float h = [self calcModelHeight:model] + 120 + area_h;
        
        //frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, h);
        
        UIView *bv1 = [[UIView alloc] initWithFrame:CGRectMake(15, 15, kScreenWidth-30, h)];
        bv1.backgroundColor = [UIColor whiteColor];
        bv1.layer.cornerRadius = 5.;
                
        MYLabel *lab1 = [self customLabel:model.info_title colorR:0x12 colorG:0x12 colorB:0x12 fontSzie:16 rect:CGRectMake(0,0,0,0)];
        [bv1 addSubview:lab1];
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bv1.mas_top).offset(15);
            make.left.equalTo(bv1.mas_left).offset(15);
        }];
        
        MYLabel *periodLab = [self customLabel:model.info_period colorR:0x47 colorG:0xc6 colorB:0x7c fontSzie:12 rect:CGRectMake(0,0,0,0)];
        [bv1 addSubview:periodLab];
        [periodLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(lab1.mas_centerY).offset(0);
            make.right.equalTo(bv1.mas_right).offset(-12);
            make.height.mas_equalTo(18);
        }];
        [periodLab setVerticalAlignment:VerticalAlignmentMiddle];
        periodLab.backgroundColor = [UIColor clearColor];
        periodLab.layer.borderColor = UIColorFromRGB(0x47c67c).CGColor;
        periodLab.textColor = UIColorFromRGB(0x47c67c);
        periodLab.layer.borderWidth = 1.;
        periodLab.layer.cornerRadius = 8.25;
        
        
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30, 0.5)];
        lineview.backgroundColor = [UIColor lightGrayColor];
        lineview.alpha = 0.3;
        [bv1 addSubview:lineview];
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lab1.mas_bottom).offset(8);
            make.left.equalTo(bv1.mas_left).offset(0);
            make.right.equalTo(bv1.mas_right).offset(0);
            make.height.mas_equalTo(0.5);
        }];
                
        MYLabel *lab2 = [self customLabel:@"采购地区:" colorR:0x66 colorG:0x66 colorB:0x66 fontSzie:14 rect:CGRectMake(0,0,0,0)];
        [bv1 addSubview:lab2];
        [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lab1.mas_bottom).offset(20);
            make.left.equalTo(bv1.mas_left).offset(15);
            make.width.mas_equalTo(65);
        }];
        
        MYLabel *lab3 = [self customLabel:model.info_addr_get colorR:0x66 colorG:0x66 colorB:0x66 fontSzie:14 rect:CGRectMake(0,0,0,0)];
        [bv1 addSubview:lab3];
        [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lab2.mas_top).offset(0);
            make.left.equalTo(lab2.mas_right).offset(5);
            make.right.equalTo(bv1.mas_right).offset(-10);
            make.height.mas_equalTo(area_h);
        }];
        lab3.lineBreakMode = NSLineBreakByCharWrapping;
                
        MYLabel *lab4 = [self customLabel:@"送货地区:" colorR:0x66 colorG:0x66 colorB:0x66 fontSzie:14 rect:CGRectMake(0,0,0,0)];
        [bv1 addSubview:lab4];
        [lab4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lab3.mas_bottom).offset(10);
            make.left.equalTo(bv1.mas_left).offset(15);
            make.width.mas_equalTo(65);
        }];
        
        int addr_h = [self calcLabHeight:model.info_addr_go fontSize:14 maxWidth:kScreenWidth-65-15*4-5];
        MYLabel *lab5 = [self customLabel:model.info_addr_go colorR:0x66 colorG:0x66 colorB:0x66 fontSzie:14 rect:CGRectMake(0,0,0,0)];
        [bv1 addSubview:lab5];
        [lab5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lab4.mas_top).offset(0);
            make.left.equalTo(lab4.mas_right).offset(5);
            make.right.equalTo(bv1.mas_right).offset(-15);
            make.height.mas_equalTo(addr_h);
        }];
        
        MYLabel *lab6 = [self customLabel:@"其它要求:" colorR:0x66 colorG:0x66 colorB:0x66 fontSzie:14 rect:CGRectMake(0,0,0,0)];
        [bv1 addSubview:lab6];
        [lab6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lab5.mas_bottom).offset(10);
            make.left.equalTo(bv1.mas_left).offset(15);
            make.width.mas_equalTo(65);
        }];
        
//        float msg_h = [self calcLabHeight:model.info_msg fontSize:14 maxWidth:kScreenWidth-65-15*4-5];
//        NSLog(@"计算的高度 = %f",msg_h);
//        MYLabel *lab7 = [self customLabel:model.info_msg colorR:0x66 colorG:0x66 colorB:0x66 fontSzie:14 rect:CGRectMake(0,0,0,0)];
//        [bv1 addSubview:lab7];
//        [lab7 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(lab6.mas_top).offset(0);
//            make.left.equalTo(lab6.mas_right).offset(5);
//            make.right.equalTo(bv1.mas_right).offset(-15);
//            make.height.mas_equalTo(msg_h);
//        }];
        
        WEAK_SELF
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            float msg_h = [self calcLabHeight:model.info_msg fontSize:14 maxWidth:kScreenWidth-65-15*4-5];
            MYLabel *lab7 = [weak_self customLabel:model.info_msg colorR:0x66 colorG:0x66 colorB:0x66 fontSzie:14 rect:CGRectMake(lab6.frame.origin.x+lab6.frame.size.width+5,lab6.frame.origin.y,kScreenWidth-65-15*4-5,msg_h)];
            [bv1 addSubview:lab7];

            int y = lab7.frame.origin.y + lab7.frame.size.height+10;
            int row = (int)model.info_imageArray.count / 4;
            if(model.info_imageArray.count % 4 != 0)
                row +=1;
            int x = 15;
            int w = (kScreenWidth-30-5*2-20)/4;
            int h = w;
            int endY = y;
            for(int i=0;i<row;i++)
            {
                int temp = 0;
                for(int j=4*i;j<model.info_imageArray.count;j++)
                {
                    UIButton *imgv = [[UIButton alloc] init];
                    imgv.frame = CGRectMake(x+(w+2)*temp++, y+(h+2)*i, w, h);
                    
//                    [imgv setImage:[model.info_imageArray objectAtIndex:i] forState:UIControlStateNormal];
                    [imgv sd_setImageWithURL:[model.info_imageArray objectAtIndex:j] forState:UIControlStateNormal];
                    
                    
                    imgv.tag = 4+j;
                    [bv1 addSubview:imgv];
                    endY = y+h*i + h;
                    if(temp > 3)
                        break;
                }
            }

            NSString *namestr = [NSString stringWithFormat:@"%@  %@",model.info_publisher,model.info_publishTime];
            MYLabel *namelab = [weak_self customLabel:namestr colorR:0x66 colorG:0x66 colorB:0x66 fontSzie:14 rect:CGRectMake(15, endY+10, kScreenWidth-30, 15)];
            [bv1 addSubview:namelab];


//            NSString *str = [NSString stringWithFormat:@"%@人看过%@人报价",model.info_seenCount,model.info_priceCount];
            NSString *str = [NSString stringWithFormat:@"%@人报价",model.info_priceCount];
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, frame.size.height-50, kScreenWidth-30, 40)];
            btn.layer.cornerRadius = 5.;
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitleColor:UIColorFromRGB(0x111111) forState:UIControlStateNormal];
            btn.titleLabel.font = CUSTOMFONT(14);
            [btn setTitle:str forState:UIControlStateNormal];
            [weak_self addSubview:btn];

        });
        
        [self addSubview:bv1];
    }
    return self;
}


- (MYLabel *)customLabel:(NSString *)string colorR:(int)cr colorG:(int)cg colorB:(int)cb fontSzie:(int)size rect:(CGRect)rect
{
    MYLabel *lab  = [[MYLabel alloc] initWithFrame:rect];
    lab.textColor = kGetColor(cr, cg, cb);
    lab.font      = [UIFont systemFontOfSize:size];  //CUSTOMFONT(size);
    lab.text      = string;
    lab.numberOfLines = 0;
    lab.textAlignment = NSTextAlignmentLeft;
    [lab setVerticalAlignment:VerticalAlignmentTop];
    return lab;
}


- (float)calcLabHeight:(NSString *)string fontSize:(int)size maxWidth:(int)w
{
    NSDictionary * dict = @{
        NSFontAttributeName : [UIFont systemFontOfSize:size]
    };
    return [string boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size.height;
}


//计算整个Model将会占据的高度
- (float)calcModelHeight:(BuyHallInfoModel *)model
{
    float h1 = [self calcLabHeight:model.info_addr_go fontSize:14 maxWidth:kScreenWidth-15*4-60-5];
    float h2 = [self calcLabHeight:model.info_msg fontSize:14 maxWidth:kScreenWidth-15*4-60-5];
    float h3 = 0;
    float imgH = (kScreenWidth-30-5*2) / 4;
    
    int c = (int)model.info_imageArray.count;
    
    int v_1 = c/4;
    int v_2 = (c%4) > 0 ? imgH : 0;
    h3 = v_1*imgH + v_2;
    
    return h1+h2+(h3+10);
}
    


@end
