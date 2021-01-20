//
//  ShelvesCell.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/31.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "ShelvesCell.h"
#import "UIImage+extern.h"
@implementation ShelvesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)indexClick:(UIButton *)sender {
    emptyBlock(self.seletecdIndeBlock,sender.tag);
}

-(void)setDic:(NSDictionary *)dic{
    NSString *url = dic[@"picUrl"];
    
    if ([url containsString:@"mp4"]) {
        
         self.goodsImage.image=[UIImage thumbnailImageForVideo:[NSURL URLWithString:url] atTime:1];
    }else{
         [self.goodsImage sd_SetImgWithUrlStr:dic[@"picUrl"] placeHolderImgName:nil];
    }
    
    
   
    self.goodsName.text = dic[@"goodName"];
    self.goodsPrice.text = [NSString stringWithFormat:@"￥%@/%@",dic[@"goodPrice"],dic[@"unit"]];
    self.timeLabel.text = [NSString stringWithFormat:@"最后擦亮时间:%@",dic[@"shineTime"]];
    self.recordLabel.text = [NSString stringWithFormat:@"30天 %@次曝光 %@次浏览",dic[@"monthExposure"],dic[@"monthBrowsing"]];
    
}
@end
