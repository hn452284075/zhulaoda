//
//  SelectedProvinceView.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/2.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SelectedProviceDelegate <NSObject>

- (void)confirmProvice:(NSArray *)parray;

@end


@interface SelectedProvinceView : UIView<SelectedProviceDelegate>

@property (nonatomic, weak) id<SelectedProviceDelegate> delegate;




- (instancetype)initWithFrame:(CGRect)frame usedArray:(NSMutableArray *)usedArray isEidt:(BOOL)flag EditArray:(NSArray *)eArray;


@end

NS_ASSUME_NONNULL_END
