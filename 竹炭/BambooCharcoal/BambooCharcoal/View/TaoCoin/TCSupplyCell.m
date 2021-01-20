//
//  TCSupplyCell.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/10/22.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "TCSupplyCell.h"

@interface TCSupplyCell()

@property (nonatomic, strong) UIImageView   *goodsimg;
@property (nonatomic, strong) UILabel       *titlelab;
@property (nonatomic, strong) UILabel       *pricelab;

@end



@implementation TCSupplyCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.goodsimg = [[UIImageView alloc] init];
        [self addSubview:self.goodsimg];
        [self.goodsimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self.mas_centerY);
            make.size.width.equalTo(@63);
            make.size.height.equalTo(@63);
        }];
        self.goodsimg.layer.masksToBounds = YES;
        self.goodsimg.layer.cornerRadius = 2.5;
        
        self.titlelab = [[UILabel alloc] init];
        [self addSubview:self.titlelab];
        [self.titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(25);
            make.left.equalTo(self.goodsimg.mas_right).offset(13);
        }];
        self.titlelab.font = CUSTOMFONT(14);
        self.titlelab.textColor = UIColorFromRGB(0x222222);
        
        
        self.pricelab = [[UILabel alloc] init];
        [self addSubview:self.pricelab];
        [self.pricelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-25);
            make.left.equalTo(self.goodsimg.mas_right).offset(13);
        }];
        self.pricelab.font = CUSTOMFONT(12);
        self.pricelab.textColor = UIColorFromRGB(0xFF4706);
        
        
        UIImageView *arrowImg = [[UIImageView alloc] init];
        [self addSubview:arrowImg];
        [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(@15);
            make.height.mas_equalTo(@15);
        }];
        arrowImg.image = IMAGE(@"rightArrow");
        
        
        UIView *sepeLine = [[UIView alloc] init];
        [self addSubview:sepeLine];
        [sepeLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-1);
            make.right.equalTo(self.mas_right).offset(-4);
            make.left.equalTo(self.mas_left).offset(15);
            make.height.mas_equalTo(0.8);
        }];
        sepeLine.backgroundColor = UIColorFromRGB(0xf2f2f2);
        sepeLine.alpha = 0.88;
        
    }
    
    return self;
}


- (void)configCellData:(TCSupplyModel *)model
{
    [self.goodsimg sd_setImageWithURL:[NSURL URLWithString:model.supply_imgurl]];
    self.titlelab.text = model.supply_title;
    self.pricelab.text = [NSString stringWithFormat:@"￥%@ /%@",model.supply_price,model.supply_unit];
    
    if(model.supply_price.length > 1 && model.supply_unit.length > 0)
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.pricelab.text]];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0,1)];
        [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:NSMakeRange(1,str.length-model.supply_unit.length-1)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(str.length-model.supply_unit.length-1,model.supply_unit.length)];
        [str addAttribute:NSForegroundColorAttributeName value:kGetColor(0xFF, 0x47, 0x06) range:NSMakeRange(0,str.length)];
        [self.pricelab setAttributedText:str];
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
