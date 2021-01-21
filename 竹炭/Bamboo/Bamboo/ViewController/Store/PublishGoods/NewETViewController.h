//
//  NewETViewController.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/2.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SetExpressModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NewETDelegate <NSObject>

- (void)expressTemplateChanged:(SetExpressModel *)em;

@end

@interface NewETViewController : BaseViewController<NewETDelegate>

@property (nonatomic, weak) id<NewETDelegate> delegate;

@property (nonatomic, strong) SetExpressModel *modelData;

@end

NS_ASSUME_NONNULL_END
