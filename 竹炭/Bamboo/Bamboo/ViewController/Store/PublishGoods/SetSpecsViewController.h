//
//  GoodsSpecsViewController.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/1.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SetSpecsInfoDelegate <NSObject>

- (void)specsConfirmInfo:(NSString *)spstr idstring:(NSString *)idstr;

@end


@interface SetSpecsViewController : BaseViewController<SetSpecsInfoDelegate>

@property (nonatomic, weak) id<SetSpecsInfoDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
