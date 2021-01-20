//
//  AddBCardViewController.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/9.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AddCardDelegate <NSObject>

- (void)addCardSuccess;

@end

@interface AddBCardViewController : BaseViewController<AddCardDelegate>

@property (nonatomic, weak) id<AddCardDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
