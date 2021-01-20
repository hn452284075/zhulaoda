//
//  WaitingPayInfoView.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/27.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "WaitingPayInfoView.h"

@implementation WaitingPayInfoView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setArr:(NSArray *)arr{
    int y =10;
    for (int a=0; a<arr.count; a++) {
        NSDictionary *dic = arr[a];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, y, 80, 20)];
        titleLabel.textColor = UIColorFromRGB(0x999999);
        titleLabel.textAlignment=0;
        titleLabel.text =[NSString stringWithFormat:@"%@:",dic[@"key"]] ;
        titleLabel.font=CUSTOMFONT(12);
        [self.payInfoView addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, y, kScreenWidth-120, 20)];
        contentLabel.textColor = UIColorFromRGB(0x333333);
        contentLabel.textAlignment=0;
        contentLabel.text =[NSString stringWithFormat:@"%@",dic[@"value"]] ;
        contentLabel.font=CUSTOMFONT(12);
        [self.payInfoView addSubview:contentLabel];
        y=y+30;
    }
    
    if (arr.count>0) {
        self.payInfoHeight.constant= (arr.count-1)*30+40;
    }
    

    
}
@end
