//
//  TCTGCell.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/10/21.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "TCTGCell.h"

@interface TCTGCell()

@property (nonatomic, strong) UIView   *backview;

@property (nonatomic, strong) UIButton *statusBtn1;
@property (nonatomic, strong) UIButton *statusBtn2;

@property (nonatomic, strong) UILabel  *contentLab;
@property (nonatomic, strong) UILabel  *priceLab;

@property (nonatomic, strong) UILabel  *numberLabel1;
@property (nonatomic, strong) UILabel  *numberLabel2;
@property (nonatomic, strong) UILabel  *numberLabel3;

@property (nonatomic, strong) TCTGModel *model;


@end


@implementation TCTGCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = UIColorFromRGB(0xf7f7f7);
        
        self.backview = [[UIView alloc] init];
        [self.contentView addSubview:self.backview];
        [self.backview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).offset(5);
            make.left.equalTo(self.mas_left).offset(15);
            make.right.equalTo(self.mas_right).offset(-15);
            make.bottom.equalTo(self.mas_bottom).offset(-5);
        }];
        self.backview.layer.cornerRadius = 5.;
        self.backview.layer.masksToBounds = YES;
        self.backview.backgroundColor = [UIColor whiteColor];
        self.backview.userInteractionEnabled = YES;
        
        self.statusBtn1 = [[UIButton alloc] init];
        [self.backview addSubview:self.statusBtn1];
        [self.statusBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backview.mas_top).offset(12);
            make.right.equalTo(self.backview.mas_right).offset(-15);
            make.width.mas_equalTo(57);
            make.height.mas_equalTo(20);
        }];
        [self customBtnBy:self.statusBtn1 backColor:UIColorFromRGB(0x46C67B) textColor:UIColorFromRGB(0xffffff) title:@"停止" tag:1];
        
        self.statusBtn2 = [[UIButton alloc] init];
        [self.backview addSubview:self.statusBtn2];
        [self.statusBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backview.mas_top).offset(12);
            make.right.equalTo(self.statusBtn1.mas_left).offset(-15);
            make.width.mas_equalTo(57);
            make.height.mas_equalTo(20);
        }];
        [self customBtnBy:self.statusBtn2 backColor:UIColorFromRGB(0xffffff) textColor:UIColorFromRGB(0x999999) title:@"进行中" tag:2];
        
        UIView *sepeLine = [[UIView alloc] init];
        [self.backview addSubview:sepeLine];
        [sepeLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backview.mas_top).offset(43);
            make.right.equalTo(self.backview.mas_right).offset(-4);
            make.left.equalTo(self.backview.mas_left).offset(4);
            make.height.mas_equalTo(0.8);
        }];
        sepeLine.backgroundColor = UIColorFromRGB(0xf2f2f2);
        sepeLine.alpha = 0.88;
        
        self.contentLab = [[UILabel alloc] init];
        self.contentLab.numberOfLines = 0;
        [self.backview addSubview:self.contentLab];
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backview.mas_top).offset(60);
            make.left.equalTo(self.backview.mas_left).offset(15);
            make.right.equalTo(self.backview.mas_right).offset(-15);
            make.height.mas_equalTo(20);
        }];
        self.contentLab.textColor = UIColorFromRGB(0x222222);
        self.contentLab.font = CUSTOMFONT(16);
        
        self.priceLab = [[UILabel alloc] init];
        [self.backview addSubview:self.priceLab];
        [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLab.mas_bottom).offset(11);
            make.left.equalTo(self.backview.mas_left).offset(15);
        }];
        self.priceLab.textColor = UIColorFromRGB(0xFF4706);
        self.priceLab.font = CUSTOMFONT(12);
        
        self.numberLabel1 = [[UILabel alloc] init];
        [self.backview addSubview:self.numberLabel1];
        [self.numberLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceLab.mas_bottom).offset(20);
            make.left.equalTo(self.backview.mas_left).offset(15);
        }];
        self.numberLabel1.textColor = UIColorFromRGB(0x999999);
        self.numberLabel1.font = CUSTOMFONT(12);
        self.numberLabel1.textAlignment = NSTextAlignmentLeft;
        
        self.numberLabel2 = [[UILabel alloc] init];
        [self.backview addSubview:self.numberLabel2];
        [self.numberLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceLab.mas_bottom).offset(20);
            make.centerX.equalTo(self.backview.mas_centerX);
        }];
        self.numberLabel2.textColor = UIColorFromRGB(0x999999);
        self.numberLabel2.font = CUSTOMFONT(12);
        self.numberLabel2.textAlignment = NSTextAlignmentCenter;
        
        self.numberLabel3 = [[UILabel alloc] init];
        [self.backview addSubview:self.numberLabel3];
        [self.numberLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceLab.mas_bottom).offset(20);
            make.right.equalTo(self.backview.mas_right).offset(-15);
        }];
        self.numberLabel3.textColor = UIColorFromRGB(0x999999);
        self.numberLabel3.font = CUSTOMFONT(12);
        self.numberLabel3.textAlignment = NSTextAlignmentRight;
        
    }
    return self;
}


- (void)configCellDataBy:(TCTGModel *)model
{
    self.model = model;
    if(model.statusFlag == 1)
    {
        [self.statusBtn1 setTitle:@"停止" forState:UIControlStateNormal];
        [self.statusBtn2 setTitle:@"进行中" forState:UIControlStateNormal];
    }
    else if(model.statusFlag == 2)
    {
        [self.statusBtn1 setTitle:@"重启" forState:UIControlStateNormal];
        [self.statusBtn2 setTitle:@"已停止" forState:UIControlStateNormal];
    }
    
    CGSize contensize = [self sizeWithText:model.contentStr font:CUSTOMFONT(16.5) maxSize:CGSizeMake(kScreenWidth-60, 500)];
    
    [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backview.mas_top).offset(60);
        make.left.equalTo(self.backview.mas_left).offset(15);
        make.right.equalTo(self.backview.mas_right).offset(-15);
        make.height.mas_equalTo(contensize.height);
    }];
    self.contentLab.text = model.contentStr;    
 
    [self.priceLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLab.mas_bottom).offset(11);
        make.left.equalTo(self.backview.mas_left).offset(15);
    }];
    self.priceLab.text = [NSString stringWithFormat:@"%@元/%@",model.priceStr,model.unitStr];
        
    [self.numberLabel1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLab.mas_bottom).offset(20);
        make.left.equalTo(self.backview.mas_left).offset(15);
    }];
    self.numberLabel1.text = [NSString stringWithFormat:@"推广搜索词:%@",model.numer1_Str];
    
    [self.numberLabel2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLab.mas_bottom).offset(20);
        make.centerX.equalTo(self.backview.mas_centerX);
    }];
    self.numberLabel2.text = [NSString stringWithFormat:@"花费田币:%@",model.numer2_Str];
    
    [self.numberLabel3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLab.mas_bottom).offset(20);
        make.right.equalTo(self.backview.mas_right).offset(-15);
    }];
    self.numberLabel3.text = [NSString stringWithFormat:@"获得点击:%@",model.numer3_Str];
    
}






- (void)customBtnBy:(UIButton *)btn backColor:(UIColor *)bcolor textColor:(UIColor *)tcolor title:(NSString *)title tag:(int)tag
{
    [btn setBackgroundColor:bcolor];
    [btn setTitleColor:tcolor forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = CUSTOMFONT(12);
    [btn addTarget:self action:@selector(statusBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
}



- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {

    NSDictionary *attrs = @{NSFontAttributeName : font};

    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;

}

- (void)statusBtnClicked:(UIButton *)sender
{
    if(sender.tag == 1)
    {
        if(self.model.statusFlag == 1)
        {
            [self.delegate statusBtnChanged:1];
        }
        if(self.model.statusFlag == 2)
        {
            [self.delegate statusBtnChanged:2];
        }
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
