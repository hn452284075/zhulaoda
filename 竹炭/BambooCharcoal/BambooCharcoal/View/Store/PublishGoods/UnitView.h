//
//  UnitView.h
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/1.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SeletecdStrBlock)(NSString *str);

@protocol UnitViewDelegate <NSObject>

@optional
- (void)confirmInfo:(int)selectedIndex;

@end

@interface UnitView : UIView <UnitViewDelegate>
@property (nonatomic, weak) id<UnitViewDelegate> delegate;
@property (nonatomic,copy)SeletecdStrBlock seletecdStrBlock;
@property (nonatomic,strong)NSArray *array;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title tagArr:(NSArray *)tagArr;

- (void)setDefaultSelected:(NSString *)str; //设置默认的选中

@end


