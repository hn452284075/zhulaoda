//
//  OfferPriceCellView.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/8.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "OfferPriceCellView.h"

@implementation OfferPriceCellView
@synthesize delegate;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame offerModel:(BuyHallOfferPriceModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //头像
        UIImageView *headimg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 38, 38)];
        [self addSubview:headimg];
//        headimg.image = IMAGE(model.op_headImg);
        [headimg sd_setImageWithURL:[NSURL URLWithString:model.op_headImg] placeholderImage:IMAGE(@"my-header")];
        headimg.layer.masksToBounds = YES;
        headimg.layer.cornerRadius = 38/2;
//        headimg.tag = 1;
        
        float name_w = [self calcLabSize:model.op_name fontSize:14 maxWidth:250].width;
        
        //名称
        UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(headimg.frame.origin.x+headimg.frame.size.width+7, 0, name_w, 14)];
        namelabel.center = CGPointMake(namelabel.center.x, headimg.center.y-5);
        [self addSubview:namelabel];
        namelabel.text = model.op_name;
        namelabel.font = [UIFont systemFontOfSize:14];
        namelabel.textColor = kGetColor(0x11, 0x11, 0x11);
//        namelabel.tag = 2;
        
        if(model.op_tag.length > 0)
        {
            UILabel *taglabel = [[UILabel alloc] init];
            [self addSubview:taglabel];
            [taglabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(namelabel.mas_right).offset(5);
                make.centerY.equalTo(namelabel.mas_centerY);
            }];
            taglabel.text = [NSString stringWithFormat:@"  %@  ",model.op_tag];
            taglabel.backgroundColor = [UIColor clearColor];
            taglabel.layer.borderColor = UIColorFromRGB(0xff270b).CGColor;
            taglabel.textColor = UIColorFromRGB(0xff270b);
            taglabel.layer.borderWidth = 1.;
            taglabel.layer.cornerRadius = 6.5;
            taglabel.font = CUSTOMFONT(11);
        }
        UILabel *addrlabel = [[UILabel alloc] init];
        [self addSubview:addrlabel];
        [addrlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(namelabel.mas_bottom).offset(5);
            make.left.equalTo(namelabel.mas_left);
        }];
        addrlabel.font = CUSTOMFONT(10);
        addrlabel.textColor = UIColorFromRGB(0x9a9a9a);
        addrlabel.text = [NSString stringWithFormat:@"%@  %@",model.op_adress,model.op_time];
        
        UIButton *chatbtn = [[UIButton alloc] init];
        [self addSubview:chatbtn];
        [chatbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headimg.mas_centerY).offset(0);
            make.right.equalTo(self.mas_right).offset(-15);
            make.width.mas_equalTo(58);
            make.height.mas_equalTo(23);
        }];
//        chatbtn.tag = 10;
        chatbtn.layer.cornerRadius = 11.5;
        chatbtn.backgroundColor = UIColorFromRGB(0x46c67c);
        [chatbtn setTitle:@"聊一聊" forState:UIControlStateNormal];
        chatbtn.titleLabel.font = CUSTOMFONT(14);
        [chatbtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [chatbtn addTarget:self action:@selector(chatBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
        chatbtn.hidden = YES;
        
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(addrlabel.mas_bottom).offset(15);
            make.left.equalTo(namelabel.mas_left);
            make.height.mas_equalTo(27);
        }];
        btn.layer.cornerRadius = 13.5;
        btn.backgroundColor = [UIColor whiteColor];
        NSString *pstr = [NSString stringWithFormat:@"  ￥%@/斤  ",model.op_price];
        [btn setTitle:pstr forState:UIControlStateNormal];
        btn.titleLabel.font = CUSTOMFONT(14);
        [btn setTitleColor:UIColorFromRGB(0x121212) forState:UIControlStateNormal];
        
        
        UILabel *commentLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 12+41+12+50, kScreenWidth-30, 100)];
        commentLab.lineBreakMode = NSLineBreakByWordWrapping;
        commentLab.numberOfLines = 0;
        commentLab.font = [UIFont systemFontOfSize:12];
        [self addSubview:commentLab];
//        commentLab.tag = 3;
        
        
        NSDictionary * dict = @{
            NSFontAttributeName : [UIFont systemFontOfSize:12]
        };
        CGSize size = [model.op_msg boundingRectWithSize:CGSizeMake(kScreenWidth-30-(headimg.frame.origin.x+headimg.frame.size.width+7), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
        
        commentLab.text = model.op_msg;
        commentLab.textColor = kGetColor(0x11, 0x11, 0x11);
        commentLab.frame = CGRectMake(headimg.frame.origin.x+headimg.frame.size.width+7, 12+41+12+50, size.width, size.height);
        
        
        int perRow = 3;
        int row = (int)model.op_imageArray.count / perRow;
        if(model.op_imageArray.count % perRow != 0)
            row +=1;
        int x = headimg.frame.origin.x+headimg.frame.size.width+7;
        int y = commentLab.frame.origin.y+size.height+15;//+50+50;
        int w = (kScreenWidth-30-(headimg.frame.origin.x+headimg.frame.size.width+7))/perRow-1;
        int h = w;
        int endY = y;
        for(int i=0;i<row;i++)
        {
            int temp = 0;
            for(int j=perRow*i;j<model.op_imageArray.count;j++)
            {
                UIButton *imgv = [[UIButton alloc] init];
                
                imgv.frame = CGRectMake(x+(w+2)*temp++, y+(h+2)*i, w, h);
                                
                [imgv sd_setImageWithURL:[model.op_imageArray objectAtIndex:j] forState:UIControlStateNormal];
                
                imgv.backgroundColor = [UIColor redColor];
                
                imgv.tag = 200+j;
                [self addSubview:imgv];
                endY = y+h*i + h;
                if(temp > 2)
                    break;
            }
        }
        
        
        
        
        
        UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(headimg.frame.origin.x+headimg.frame.size.width+7, endY+10, kScreenWidth-30-(headimg.frame.origin.x+headimg.frame.size.width+7), 0.5)];
        lineview.backgroundColor = UIColorFromRGB(0xdedede);
        lineview.alpha = 1.;
        lineview.tag = 100;
        [self addSubview:lineview];
        
    }
    return self;
}


- (CGSize)calcLabSize:(NSString *)string fontSize:(int)size maxWidth:(int)w
{
    NSDictionary * dict = @{
        NSFontAttributeName : [UIFont systemFontOfSize:size]
    };
    return [string boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size;
}


- (void)chatBtnClicked:(UIButton *)sender event:(id)event
{    
    [self.delegate offerPriceCellChatAction:sender event:self];
}


@end
