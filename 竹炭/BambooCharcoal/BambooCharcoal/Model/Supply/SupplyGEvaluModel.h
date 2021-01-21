//
//  SupplyGEvaluModel.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/14.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SupplyGEvaluModel : NSObject


//供应大厅 评价

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *delivery;
@property (nonatomic, strong) NSString *evaluateDate;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSMutableArray *picUrls;
@property (nonatomic, strong) NSString *purchase;
@property (nonatomic, strong) NSString *specification;
@property (nonatomic, strong) NSString *userIcon;


@end

NS_ASSUME_NONNULL_END
