//
//  SetExpressViewController.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/2.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SetExpressDelegate <NSObject>

- (void)confirmExpressInfo:(NSString *)exway name:(NSString *)moduldname moduleId:(int)mid;

@end

@interface SetExpressViewController : BaseViewController<SetExpressDelegate>

@property (nonatomic, weak) id<SetExpressDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
