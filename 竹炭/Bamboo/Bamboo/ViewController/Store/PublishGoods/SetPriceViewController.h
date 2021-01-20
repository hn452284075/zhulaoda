//
//  SetPriceViewController.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/1.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SetPriceCompelteDelegate <NSObject>

- (void)priceInfoOfSpecs:(NSString *)unit sunit:(NSString *)sunit specsArr:(NSArray *)arr;

@end

@interface SetPriceViewController : BaseViewController<SetPriceCompelteDelegate>

@property (nonatomic, weak) id<SetPriceCompelteDelegate> delegate;
@property (nonatomic, assign) int categateID;

@property (nonatomic, strong) NSString *defaultUnit;
@property (nonatomic, strong) NSString *defaultSunit;
@property (nonatomic, strong) NSArray  *defaultArr;

@end

NS_ASSUME_NONNULL_END
