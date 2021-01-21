//
//  RefusedShowView.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/1.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^RefusedBlock)(NSString * _Nullable str);
NS_ASSUME_NONNULL_BEGIN

@interface RefusedShowView : UIView
@property (nonatomic,strong)UIView *viewBG;
@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,copy)RefusedBlock deliveryBlock;
-(instancetype)initWithRefusedFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
