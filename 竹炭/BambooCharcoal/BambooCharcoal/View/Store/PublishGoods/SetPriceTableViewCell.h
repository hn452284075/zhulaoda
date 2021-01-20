//
//  SetPriceTableViewCell.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/1.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SetPriceDelegate <NSObject>

- (void)addOrSubFunction:(int)flag row:(int)row; //0加 --- 1减
- (void)filedTextChanged:(NSString *)filed1Str filed2:(NSString *)filed2Str event:(id)event;

@end

@interface SetPriceTableViewCell : UIView<SetPriceDelegate>//UITableViewCell

@property (nonatomic, weak) id<SetPriceDelegate> delegate;
@property (nonatomic, assign) int   row;

- (void)configCellTitle:(NSString *)title
              actionImg:(NSString *)image
               f1String:(NSString *)f1string
        f1DefaultString:(NSString *)fd1string
               f2String:(NSString *)f2string
        f2DefaultString:(NSString *)fd2string
              msgString:(NSString *)string;

- (void)configCellTitleShow:(BOOL)flag1
                     filed1:(BOOL)flag2
                     filed2:(BOOL)flag3
                     msglab:(BOOL)flag4
                   arrowImg:(BOOL)flag5;

@end

NS_ASSUME_NONNULL_END
