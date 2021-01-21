//
//  PublishProcurementVC.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/8.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PublishProcurementVCDelegate <NSObject>

- (void)publishProcurementSuccess;

@end

@interface PublishProcurementVC : BaseViewController<PublishProcurementVCDelegate>

@property (nonatomic, weak) id<PublishProcurementVCDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
