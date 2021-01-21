//
//  OSPayViewController.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/10/15.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OSPayViewController : BaseViewController

@property (nonatomic, retain) NSString *shopName;
@property (nonatomic, retain) NSString *cateName;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, retain) NSString *ownerName;

@property (nonatomic, retain) NSString *orderSn;
@property (nonatomic, retain) NSString *totalAmount;

@end

NS_ASSUME_NONNULL_END
