//
//  ManageStoreCellView.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/4.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ManageStoreCellView : UIView

- (void)configCellInfoImage:(NSString *)imagename
                      title:(NSString *)title
                     status:(NSString *)subtitle;

- (void)configCellInfoShowImage:(BOOL)flag1
                      showTitle:(BOOL)flag2
                   showSubTitle:(BOOL)flag3
                      showArrow:(BOOL)flag4;

@end

NS_ASSUME_NONNULL_END
