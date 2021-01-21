//
//  PublishGoodsFooterView.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/2.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "PublishGoodsFooterView.h"

@implementation PublishGoodsFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)indexClick:(UIButton *)sender {
    emptyBlock(self.seletecdIndexBlock,sender.tag);
}

@end
