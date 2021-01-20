//
//  AppDelegate.h
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/15.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTabBarController.h"

typedef void(^AppDelegateEnterBackgroundHandler)(void);

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic)UIWindow *window;
@property (nonatomic,strong)MainTabBarController *mainVC;

@property (copy, nonatomic) AppDelegateEnterBackgroundHandler enterBackgroundHandler;

@end

