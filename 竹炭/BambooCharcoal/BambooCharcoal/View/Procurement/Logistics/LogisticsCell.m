//
//  LogisticsCell.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/9.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "LogisticsCell.h"

@implementation LogisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupUI];
    }
    
    return self;
}

- (void)reloadDataWithModel:(LogisticModel*)model {
    self.statusLabel.text = model.status;
    self.infoLabel.text = model.dsc;
    self.timeLabel.text=@"昨天";
    self.timeLabel2.text=model.date;
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (isEmpty(model.status)) {
          make.left.mas_equalTo(self);
          make.top.mas_equalTo(10);
        }else{
          make.left.top.mas_equalTo(self);
        }
          
          make.width.mas_equalTo(38);
    }];
    WEAK_SELF
    [_timeLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.mas_equalTo(weak_self.timeLabel.mas_bottom);
      make.left.mas_equalTo(self);
      make.width.mas_equalTo(38);
    }];
    
    
    
    [self setNeedsDisplay];
}

-(void)setupUI{
      
        
        UILabel *status = [[UILabel alloc]init];
        status.numberOfLines=0;
        status.font = [UIFont systemFontOfSize:14];
        status.textColor = UIColorFromRGB(0x9a9a9a);
        [self addSubview:status];
        _statusLabel = status;
     
        UILabel *info= [[UILabel alloc]init];
        info.numberOfLines=0;
        info.font = [UIFont systemFontOfSize:12];
        info.textColor = UIColorFromRGB(0x9a9a9a);
        [self addSubview:info];
        _infoLabel = info;
    
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = UIColorFromRGB(0x9a9a9a);
        _timeLabel.textAlignment=2;
        _timeLabel.font=CUSTOMFONT(9);
        [self addSubview:_timeLabel];
        _timeLabel2 = [[UILabel alloc]init];
        _timeLabel2.textColor = UIColorFromRGB(0x9a9a9a);
        _timeLabel2.textAlignment=2;
        _timeLabel2.font=CUSTOMFONT(9);
        [self addSubview:_timeLabel2];
    

      [status mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(self).offset(2);
          make.left.mas_equalTo(self).offset(70);
          make.right.mas_equalTo(self).offset(-10);
       }];
    
      [info mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.mas_equalTo(self).offset(70);
           make.bottom.mas_equalTo(self).offset(-10);
           make.right.mas_equalTo(self).offset(-10);
           make.top.mas_equalTo(status.mas_bottom).offset(5);
      }];
       
    
       
      
}
- (void)setCurrentTextColor:(UIColor *)currentTextColor {
    
    self.infoLabel.textColor = currentTextColor;
}



- (void)setCurrented:(BOOL)currented {
    
    _currented = currented;
    if (currented) {
        self.infoLabel.textColor = kGetColor(0, 0, 0);
    } else {
        self.infoLabel.textColor = UIColorFromRGB(0x9a9a9a);
    }
}

- (void)drawRect:(CGRect)rect {
    

    
    //去掉分割线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
 
    //画竖线
    CGFloat height = self.bounds.size.height;
    CGFloat cicleWith = 8;
    UIBezierPath *topBezier = [UIBezierPath bezierPath];
   [topBezier moveToPoint:CGPointMake(100/2.0, 0)];
   [topBezier addLineToPoint:CGPointMake(100/2.0, height)];
   topBezier.lineWidth = 1.0;
   UIColor *stroke = UIColorFromRGB(0xEAEAEA);
   [stroke set];
   [topBezier stroke];
    
    for(UIView *view in [self subviews])
    {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    CGFloat topFloat=5;
   if (isEmpty(self.statusLabel.text)) {
       topFloat=15;
       UIBezierPath *cicle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100/2.0-cicleWith/2.0,topFloat, cicleWith, cicleWith)];
       UIColor *cColor = UIColorFromRGB(0xEAEAEA);
       [cColor set];
       [cicle fill];
       [cicle stroke];
       return;
   }
    UIBezierPath *cicle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100/2.0-cicleWith/2.0,topFloat, cicleWith, cicleWith)];
        UIColor *cColor = UIColorFromRGB(0xEAEAEA);
        [cColor set];
        [cicle fill];
        [cicle stroke];
  
    
    if (_index==6) {
     UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100/2.0 - 23/2.0,0, 23, 23)];
      [imgView setImage:[UIImage imageNamed:@"yixiadan"]];
      [self addSubview:imgView];
        
    }else if(_index==5){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100/2.0 - 23/2.0,0, 23, 23)];
        [imgView setImage:[UIImage imageNamed:@"lanjian"]];
        [self addSubview:imgView];
    }else if(_index==4){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100/2.0 - 23/2.0,0, 23, 23)];
       [imgView setImage:[UIImage imageNamed:@"yunshu"]];
       [self addSubview:imgView];
    }else if(_index==3){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100/2.0 - 23/2.0,0, 23, 23)];
      [imgView setImage:[UIImage imageNamed:@"paisong"]];
       [self addSubview:imgView];
    }else if(_index==2){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100/2.0 - 23/2.0,0, 23, 23)];
      [imgView setImage:[UIImage imageNamed:@"daiqu"]];
       [self addSubview:imgView];
    }else if(_index==1){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100/2.0 - 23/2.0,0, 23, 23)];
      [imgView setImage:[UIImage imageNamed:@"qianshou"]];
       [self addSubview:imgView];
    }else if(_index==0){
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100/2.0 - 23/2.0,0, 23, 23)];
      [imgView setImage:[UIImage imageNamed:@"yishouhuo"]];
       [self addSubview:imgView];
    }else {
  
    }
    
//    if (self.currented) {
//
////        UIBezierPath *cicle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(100/2.0 - cicleWith/2.0, height/2.0 - cicleWith/2.0, cicleWith, cicleWith)];
////
////        cicle.lineWidth = cicleWith/3.0;
////        UIColor *cColor = DWQRGBAColor(255, 128, 0, 1.0);
////        [cColor set];
////        [cicle fill];
////
////        UIColor *shadowColor = DWQRGBAColor(255, 128, 0, 0.5);
////        [shadowColor set];
////
////
////        [cicle stroke];
//
//
////    } else {
//
//
//
//
////    }
    
    if (self.hasDownLine) {
        
        UIBezierPath *downBezier = [UIBezierPath bezierPath];
        [downBezier moveToPoint:CGPointMake(100/2.0, height/2.0 + cicleWith/2.0 + cicleWith/6.0)];
        [downBezier addLineToPoint:CGPointMake(100/2.0, height)];
        
        downBezier.lineWidth = 1.0;
        UIColor *stroke = UIColorFromRGB(0xEAEAEA);
        [stroke set];
        [downBezier stroke];
    }
}
@end
