//
//  NTESLDMainViewController.h
//  NTESLiveDetectPublicDemo
//
//  Created by Ke Xu on 2019/10/11.
//  Copyright © 2019 Ke Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol NTESDetectedDelegate <NSObject>

- (void)NTESDetectResult:(int)flag; //flag==1 成功  flag==0 失败

@end

@interface NTESLDMainViewController : BaseViewController<NTESDetectedDelegate>

@property (nonatomic, weak)   id<NTESDetectedDelegate> delegate;

@property (nonatomic, strong) NSString *nameString;
@property (nonatomic, strong) NSString *cardString;

@end

NS_ASSUME_NONNULL_END
