//
//  BCUnboundViewController.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol UNBoundDelegate <NSObject>

- (void)unboundSuccess;

@end

@interface BCUnboundViewController : BaseViewController<UNBoundDelegate>

@property (nonatomic, weak) id<UNBoundDelegate> delegate;

@property (nonatomic, strong) NSString *cardNo;
@property (nonatomic, strong) NSString *cardName;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) NSString *ownerPhone;

@end

NS_ASSUME_NONNULL_END
