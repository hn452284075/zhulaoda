//
//  PriceModel.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/1.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetPriceModel : NSObject

@property (nonatomic, strong) NSString *priceSpec;
@property (nonatomic, strong) NSString *pricevalue;
@property (nonatomic, strong) NSString *priceMsg;

@end

NS_ASSUME_NONNULL_END
