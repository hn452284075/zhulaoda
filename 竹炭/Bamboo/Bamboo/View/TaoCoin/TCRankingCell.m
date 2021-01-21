//
//  TCRankingCell.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/10/24.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "TCRankingCell.h"
#import "UIView+Frame.h"
@implementation TCRankingCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.backgroundColor=KViewBgColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _subView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth-30,55)];
        _subView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_subView];
        
        _index = [[UILabel alloc]initWithFrame:CGRectMake(30, 19, 34, 34)];
        _index.font=CUSTOMFONT(15);
        _index.textColor = UIColorFromRGB(0x333333);
        [_subView addSubview:_index];
        
        _bgimg = [[UIImageView alloc] initWithFrame:CGRectMake(18, 19, 34, 34)];
        _bgimg.layer.cornerRadius=19;
        [_subView addSubview:_bgimg];
        
        
       
        
        _img = [[UIImageView alloc] initWithFrame:CGRectMake(_index.right+11, 17, 38, 38)];
        _img.layer.cornerRadius=19;
        [_subView addSubview:_img];
        
        _name = [[UILabel alloc]initWithFrame:CGRectMake(_img.right+11, 32, 150, 14)];
        _name.textColor = UIColorFromRGB(0x333333);
        _name.textAlignment=0;
        _name.text = @"赞涨";
        _name.font=CUSTOMFONT(14);
        [_subView addSubview:_name];
        
        _price = [[UILabel alloc]initWithFrame:CGRectMake(_subView.width-20-150, 31, 150, 15)];
        _price.textColor = KCOLOR_Main;
        _price.textAlignment=2;
        _price.text = @"1090";
        _price.font=CUSTOMFONT(15);
        [_subView addSubview:_price];
        
    }
    return  self;
}

-(void)data:(NSDictionary *)dic AndIndex:(NSInteger)num{
    
    if (num==1) {
        _bgimg.image=IMAGE(@"dym");
    }else if (num==2){
        _bgimg.image=IMAGE(@"dem");
    }else if (num==3){
        _bgimg.image=IMAGE(@"dsm");
    }else{
        _index.text = [NSString stringWithFormat:@"%ld",num];
    }
    
    [self.img sd_SetImgWithUrlStr:dic[@"img"] placeHolderImgName:@"my-header"];
    self.name=dic[@"name"];
    self.price=dic[@"price"];
    
}
@end
