//
//  ShowHomeView.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/27.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SeletecdIndexBlock)(NSInteger index);
@interface ShowHomeView : NSObject
+ (instancetype)sharedInstance;
-(void)showLeftTile:(NSString *)letf withRight:(NSString *)right AndBlock:(SeletecdIndexBlock)block;
@property (nonatomic,strong)UIView *viewBG;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,copy)SeletecdIndexBlock seletecdIndexBlock;
@end

NS_ASSUME_NONNULL_END
