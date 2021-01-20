//
//  PublishAppraiseVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/3.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "PublishAppraiseVC.h"
#import "PublishAppraiseView.h"
#import "HXPhotoView.h"
#import "UIView+Frame.h"
#import "UIBarButtonItem+BarButtonItem.h"
@interface PublishAppraiseVC ()<HXPhotoViewDelegate>
@property (strong, nonatomic) PublishAppraiseView *headerView;
@property (nonatomic,strong)HXPhotoView *photoView;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic,strong)NSMutableArray *imageDataArr;
@end

@implementation PublishAppraiseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageTitle=@"发表评价";
    [self initUI];
    
}
#pragma mark ------------------------Init---------------------------------
-(void)initUI{
    
    UIBarButtonItem *right = [UIBarButtonItem initWithTitle:@"发布" titleColor:KCOLOR_Main AndSetButtonSize:CGSizeMake(50, 20) titleSize:16 target:self action:@selector(rightClick)];
    self.navigationItem.rightBarButtonItem=right;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.backgroundColor=KViewBgColor;
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:self.headerView];
            
        
}

#pragma mark ------------------------View Event---------------------------
-(void)rightClick{
    
}

#pragma mark ------------------------Delegate-----------------------------
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    
    self.imageDataArr = [NSMutableArray arrayWithArray:allList];
   
    
    NSSLog(@"%@",allList);
 }

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"frame:%@",NSStringFromCGRect(frame));
    _headerView.photoBGViewHeight.constant =frame.size.height;
     self.scrollView.contentSize = CGSizeMake(self.scrollView.width, kScreenHeight+frame.size.height);
}


#pragma mark ------------------------Getter / Setter----------------------
- (PublishAppraiseView *)headerView{
    if (!_headerView) {
           _headerView = BoundNibView(@"PublishAppraiseView", PublishAppraiseView);
            _headerView.frame=CGRectMake(0, 0, kScreenWidth, 665);
            
            _photoView = [[HXPhotoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 14*2, 0) manager:self.manager];
             _photoView.delegate = self;
             _photoView.backgroundColor = [UIColor whiteColor];
             _photoView.spacing=10;
             [_photoView refreshView];
             [_headerView.photoBGView addSubview:_photoView];
        
    }
       return _headerView;
}

- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.configuration.openCamera = YES;
        _manager.configuration.photoMaxNum = 12;
        _manager.configuration.videoMaxNum = 3;
        _manager.configuration.maxNum = 15;
//        NSMutableArray *array = [NSMutableArray arrayWithObjects:@"http://oss-cn-hangzhou.aliyuncs.com/tsnrhapp/shop/photos/857980fd0acd3caf9e258e42788e38f5_0.gif",@"http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/0034821a-6815-4d64-b0f2-09103d62630d.jpg",@"http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/0be5118d-f550-403e-8e5c-6d0badb53648.jpg",@"http://tsnrhapp.oss-cn-hangzhou.aliyuncs.com/1466408576222.jpg", nil];
//          [_manager addNetworkingImageToAlbum:array selected:YES];
        
    }
    return _manager;
}

@end
