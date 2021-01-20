//
//  UserInfoModel.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/19.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "annexes.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : NSObject

@property (nonatomic, strong)   NSString *userid;
@property (nonatomic, strong)   NSString *accid;
@property (nonatomic, assign)   int annexVerifyState;
@property (nonatomic, strong)   NSMutableArray <annexes *> *annexes;
@property (nonatomic, strong)   NSString *area;
@property (nonatomic, strong)   NSString *areaId;
@property (nonatomic, strong)   NSString *capacity;
@property (nonatomic, strong)   NSString *avatar;
@property (nonatomic, strong)   NSString *major;
@property (nonatomic, strong)   NSString *myself;
@property (nonatomic, strong)   NSString *nickname;


@end

NS_ASSUME_NONNULL_END
