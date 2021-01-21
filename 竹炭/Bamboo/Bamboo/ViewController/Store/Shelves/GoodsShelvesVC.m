//
//  GoodsShelvesVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/31.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "GoodsShelvesVC.h"
#import "HMSegmentedControl.h"
#import "HMSegementController.h"
#import "ShelvesDetailsVC.h"
#import "PublishGoodsVC.h"
@interface GoodsShelvesVC ()
@property (strong, nonatomic) HMSegmentedControl *topBarControl;
@property (strong, nonatomic) HMSegementController *topBarController;
@property (nonatomic,strong)  NSArray *classNames;
@end

@implementation GoodsShelvesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageTitle=@"我的商品";
     [self _initSegementControll];
     self.view.backgroundColor  = [UIColor whiteColor];
    
     if (self.topBarControl) {
        [self.topBarController setSegementIndex:self.seletecdIndex animated:YES];
        
     }
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(kScreenWidth-15-71,kScreenHeight-kStatusBarAndNavigationBarHeight-71-46.5, 71, 71);
    
    [addBtn setImage:IMAGE(@"addProduct") forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
}

-(void)addBtnClick{
    PublishGoodsVC *vc = [[PublishGoodsVC alloc]init];
    [self navigatePushViewController:vc animate:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark ------------------------Init---------------------------------
- (void)_initSegementControll {
    self.classNames =  @[@"已上架",@"已下架"];
    self.topBarControl = [[HMSegmentedControl alloc] initWithSectionTitles:self.classNames];
    self.topBarControl.frame = CGRectMake(0, 6, 220, 26);
    self.topBarControl.backgroundColor = [UIColor whiteColor];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 38)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    self.topBarControl.center=bgView.center;
    [bgView addSubview:self.topBarControl];
    
    self.topBarControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    
    self.topBarControl.font = [UIFont fontWithName:@"PingFang SC" size:14.0f];
    self.topBarControl.textColor = KCOLOR_MAIN_TEXT;
    self.topBarControl.selectedTextColor = KCOLOR_Main;
    self.topBarControl.selectionIndicatorColor = KCOLOR_Main;
    self.topBarControl.selectionIndicatorHeight=2;
    [self _creatHMSegementController];
    
  
    
}

#pragma mark ------------------------Private------------------------------
- (void)_creatHMSegementController {
    WEAK_SELF
    self.topBarController = [[HMSegementController alloc] initWithSegementControl:self.topBarControl segementControllerFrame:CGRectMake(0, 38, kScreenWidth,kScreenHeight-38) childSegementControllClass:[ShelvesDetailsVC class] childControllersCompletedAddedBlock:^(NSArray *childControllers) {
        [weak_self _assignClassCodeForChildVcs:childControllers];
        
    }];
    self.topBarController.indexChangeBlock = ^(NSInteger index, UIViewController *childVc){
     
        ShelvesDetailsVC  *vc  = (ShelvesDetailsVC *)childVc;
        [vc _initLoad];
        
    };
    
}

- (void)_assignClassCodeForChildVcs:(NSArray *)chilVcs {
    NSArray *array = @[@"1",@"0"];
    
    for (NSInteger i=0; i<chilVcs.count; i++) {

        ShelvesDetailsVC  *vc  = (ShelvesDetailsVC *)chilVcs[i];
        vc.typeId = array[i];
    }
}
@end
