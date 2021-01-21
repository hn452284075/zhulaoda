//
//  SetDetailInfoViewController.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/3.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol SetDetailInfoDelegate <NSObject>

- (void)detailInfoMsg:(NSString *_Nullable)string;

@end


NS_ASSUME_NONNULL_BEGIN

@interface SetDetailInfoViewController : BaseViewController<SetDetailInfoDelegate>
@property (nonatomic,strong)NSString *desc;
@property (nonatomic, weak) id<SetDetailInfoDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
