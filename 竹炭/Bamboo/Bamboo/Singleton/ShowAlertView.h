//
//  ShowAlertView.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/27.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SeletecdBlock)(NSInteger index);

@interface ShowAlertView : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic,strong)UIView *viewBG;
@property (nonatomic,strong)UIView *middleView;
@property (nonatomic,copy)SeletecdBlock seletecdBlock;
-(void)show:(NSString *)title;
@end


