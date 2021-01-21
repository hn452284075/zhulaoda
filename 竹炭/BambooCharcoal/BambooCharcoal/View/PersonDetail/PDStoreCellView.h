//
//  PDStoreCellView.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/10.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol PDStoreCellViewDelegate <NSObject>

- (void)PDCellViewChangeShowStatus:(int)cellHeight;

- (void)PDCellViewClickedItem:(NSString *)item;

@end


@interface PDStoreCellView : UIView<PDStoreCellViewDelegate>

@property (nonatomic, weak) id<PDStoreCellViewDelegate> delegate;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *msgLabl_1;
@property (nonatomic, strong) UILabel *msgLabl_2;
@property (nonatomic, strong) UILabel *msgLabl_3;

@property (nonatomic, strong) UIButton  *defaultBtn_1;
@property (nonatomic, strong) UIButton  *defaultBtn_2;
@property (nonatomic, strong) UIButton  *defaultBtn_3;
@property (nonatomic, strong) UIButton  *moreBtn;


- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title vaule1Str:(NSString *)value1 value2Str:(NSString *)value2 value3Str:(NSString *)value3 tagArray:(NSArray *)arr showFlag:(BOOL)flag;


@end

NS_ASSUME_NONNULL_END
