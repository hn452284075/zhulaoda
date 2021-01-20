//
//  LogisticModel.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/9.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "LogisticModel.h"
@interface LogisticModel ()

@property(assign, nonatomic)CGFloat tempHeight;

@end

@implementation LogisticModel
- (CGFloat)height {
    
    if (_tempHeight == 0) {
        
        NSDictionary * dict=[NSDictionary dictionaryWithObject: [UIFont systemFontOfSize:12] forKey:NSFontAttributeName];
        
        CGRect rect=[self.dsc boundingRectWithSize:CGSizeMake(kScreenWidth - 70 - 10, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil];
        
        if (self.status.length>0) {
        _tempHeight = rect.size.height+14+25+7;
        }else{
        _tempHeight = rect.size.height+25;
        }
        
    }
    
    return _tempHeight;
}
@end
