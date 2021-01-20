//
//  PDHeadInfoTextView.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PDHeadInfoTextViewDelegate <NSObject>

- (void)changedMsgShowHeight:(int)height;

@end

@interface PDHeadInfoTextView : UIView<PDHeadInfoTextViewDelegate>

@property (nonatomic, strong) id<PDHeadInfoTextViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title msg:(NSString *)msg imageArray:(NSArray *)arr showFlag:(BOOL)flag;

@end

NS_ASSUME_NONNULL_END
