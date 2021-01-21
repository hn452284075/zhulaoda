//
//  LogisticModel.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/9.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LogisticModel : BaseModel
@property (copy, nonatomic)NSString *dsc;
@property (copy, nonatomic)NSString *date;
@property (copy, nonatomic)NSString *status;
@property (assign, nonatomic, readonly)CGFloat height;
@end

NS_ASSUME_NONNULL_END
