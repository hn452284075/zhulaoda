//
//  CheckStatusViewController.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/4.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CheckStatusDelegate <NSObject>

- (void)checkStatusFinish:(int)flag;

@end

@interface CheckStatusViewController : BaseViewController<CheckStatusDelegate>

@property (nonatomic, weak) id<CheckStatusDelegate> delegate;

@property (nonatomic, assign) int checkResult;  //根据传过来的值确定  成功  失败

@property (nonatomic, strong) NSString *detect_name;
@property (nonatomic, strong) NSString *detect_card;
@property (nonatomic, strong) NSString *detect_token;
@property (nonatomic,assign)BOOL isStorePush;
@end

NS_ASSUME_NONNULL_END
