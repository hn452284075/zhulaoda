//
//  MeViewController.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/15.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "MeViewController.h"
#import "CustomFlowLayout.h"
#import "MeCollectionViewCell.h"
#import "MeHeaderView.h"
#import "AddressMangerController.h"
#import "CollectGoodsVC.h"
#import "CollectStoreVC.h"
#import "ProcurementOrderVC.h"
#import "LoginViewController.h"
#import "BanKCardViewController.h"
#import "PersonDetailViewController.h"
#import "PersonalDataVC.h"
#import "Util.h"
#import "BankCardListViewController.h"
#import "CertificationViewController.h"
#import "SetViewController.h"
#import "VertifySucessController.h"
#import "TCMainViewController.h"
@interface MeViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic,strong)UICollectionViewFlowLayout *flowlayout;
@property (nonatomic,strong)MeHeaderView *headerV;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AddCardSuceess) name:@"AddCardSuceess" object:nil];
}

- (void)AddCardSuceess
{
    BankCardListViewController *vc = [[BankCardListViewController alloc] init];
    [self navigatePushViewController:vc animate:NO];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.fd_prefersNavigationBarHidden=YES;
   
    if(UserIsLogin)
    {
        [self getUserInfo];
        self.headerV.editBtn.hidden = NO;
        self.headerV.phoneLabel.hidden = NO;
        
    }
    else{
        [self.headerV.loginBtn setTitle:@"点击登录" forState:UIControlStateNormal];
        self.headerV.editBtn.hidden = YES;
        self.headerV.headerImg.image=IMAGE(@"my-header");
        self.headerV.phoneLabel.hidden = YES;
        [self.headerV.vertifyStatusBtn setTitle:@"去认证 >" forState:UIControlStateNormal];
        self.headerV.goodsNum.text = @"-";
        self.headerV.storeNum.text = @"-";
        self.headerV.recordsNum.text = @"-";
    }
}
 
-(UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}


- (void)_init{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];

    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

}

#pragma mark ------------------------Delegate-----------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 1;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        
    MeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeCollectionViewCell" forIndexPath:indexPath];
    WEAK_SELF
    cell.indexBlock = ^(NSInteger index) {
        [weak_self jumoIndexPage:index];
    };
        
    return cell;
   
}





//设置头尾部内容
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
 
    if (kind == UICollectionElementKindSectionHeader) {
        
        self.headerV  = (MeHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MeHeaderView" forIndexPath:indexPath];
        self.headerV.editBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.headerV.editBtn.layer.cornerRadius = 8.5;
        
        self.headerV.editBtn.backgroundColor = [UIColor colorWithRed:0xff/255. green:0xff/255. blue:0xff/255. alpha:0.35];
        [self.headerV.editBtn setTitle:@"   完善资料   " forState:UIControlStateNormal];
        [self.headerV.editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.headerV.headerImg.userInteractionEnabled = YES;
        self.headerV.editBtn.hidden = YES;
        WEAK_SELF
        if (UserIsLogin)
        {
//            [self.headerV.loginBtn setTitle:[UserModel sharedInstance].username forState:UIControlStateNormal];
            self.headerV.editBtn.hidden = NO;
            self.headerV.phoneLabel.hidden = NO;
            
            if([[UserModel sharedInstance].verifyStatus intValue] == 1)
            {
                [self.headerV.vertifyStatusBtn setTitle:@"已实名" forState:UIControlStateNormal];
            }else
            {
                [self.headerV.vertifyStatusBtn setTitle:@"去认证 >" forState:UIControlStateNormal];
            }
        }
        
        [self.headerV.certificationView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self jumoIndexPage:2];
        }];
        
        //退出登录
        [self.headerV.loginoutBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self jumoIndexPage:3];
        }];
        
        //查看个人店铺资料

        [self.headerV.loginBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
           
            [weak_self jumoIndexPage:4];
        }];
        
        //编辑个人资料
        [self.headerV.editBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self jumoIndexPage:5];
        }];
        [self.headerV.headerImg addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self jumoIndexPage:4];
        }];
        self.headerV.phoneLabel.userInteractionEnabled = YES;
        [self.headerV.phoneLabel addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                [weak_self jumoIndexPage:4];
        }];
      
        
        //收藏产品
        [self.headerV.goodsBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self jumoIndexPage:6];
        }];
        //收藏店铺
        [self.headerV.storeBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self jumoIndexPage:7];
        }];
        //浏览记录
        [self.headerV.recordView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
           [weak_self jumoIndexPage:8];
        }];
        //认证
        [self.headerV.certificationBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
           [weak_self jumoIndexPage:9];
        }];
    }
    return self.headerV;
}

#pragma mark ------------------------Page Navigate------------------------
-(void)jumoIndexPage:(NSInteger)index{
    if (!UserIsLogin) {
       [self _jumpLoginPage];
        return;
    }
    
    
    switch (index) {
         case 2:
         {
             //认证
             if([[UserModel sharedInstance].verifyStatus intValue] == 1)
             {
                 VertifySucessController *vc = [[VertifySucessController alloc] init];
                 [self navigatePushViewController:vc animate:YES];
             }
             else
             {
                 CertificationViewController *vc = [[CertificationViewController alloc] init];
                 [self navigatePushViewController:vc animate:YES];
             }
            
         }
            break;
        case 3:  //退出登录
        {
            [self showAlertWithTitle:@"提示" message:@"确定要退出吗" sureTitle:@"确定" cancelTitle:@"取消" sureAction:^(UIAlertAction *action) {
                
                [self.headerV.loginBtn setTitle:@"点击登录" forState:UIControlStateNormal];
                self.headerV.editBtn.hidden = YES;
                self.headerV.phoneLabel.hidden = YES;
                
                [[UserModel sharedInstance] clearUserInfo];
                [self _jumpLoginPage];
            } cancelAction:^(UIAlertAction *action) {
                
            }];
            
        }
            break;
        case 4:
        {
            
            //跳转到介绍页
            PersonDetailViewController *vc = [[PersonDetailViewController alloc] init];
            [self navigatePushViewController:vc animate:YES];
           
        }
            break;
        case 5://登录
        {
            
            PersonalDataVC *vc = [[PersonalDataVC alloc]init];
            [self navigatePushViewController:vc animate:YES];

        }
            break;
        case 6://收藏产品
            {
                CollectGoodsVC *vc = [[CollectGoodsVC alloc]init];
                vc.pageTitle=@"关注商品";
                vc.isFocus=YES;
                [self navigatePushViewController:vc animate:YES];
                //田bi
//                TCMainViewController *vc = [[TCMainViewController alloc] init];
//                [self navigatePushViewController:vc animate:YES];

            }
            break;
            
        case 7://收藏店铺
            {
                CollectStoreVC *vc = [[CollectStoreVC alloc]init];
                [self navigatePushViewController:vc animate:YES];

            }
            break;
            
        case 8://浏览记录
            {
                CollectGoodsVC *vc = [[CollectGoodsVC alloc]init];
                vc.pageTitle=@"浏览记录";
                [self navigatePushViewController:vc animate:YES];
            }
            break;
            
        case 9://认证
            {
            
            }
            break;
                
        case 10://全部
            {
                ProcurementOrderVC *vc = [[ProcurementOrderVC alloc]init];
                vc.currentIndex=0;
                [self navigatePushViewController:vc animate:YES];

            }
            break;
            
        case 11://待付款
            {
                ProcurementOrderVC *vc = [[ProcurementOrderVC alloc]init];
                vc.currentIndex=1;
                [self navigatePushViewController:vc animate:YES];
            }
            break;
        case 12://待发货
            {
                ProcurementOrderVC *vc = [[ProcurementOrderVC alloc]init];
                vc.currentIndex=2;
                [self navigatePushViewController:vc animate:YES];
            }
            break;
        case 13://待收货
            {
                ProcurementOrderVC *vc = [[ProcurementOrderVC alloc]init];
                vc.currentIndex=3;
                [self navigatePushViewController:vc animate:YES];
           
            }
            break;
        case 14://待评价
            {
                ProcurementOrderVC *vc = [[ProcurementOrderVC alloc]init];
                vc.currentIndex=4;
                [self navigatePushViewController:vc animate:YES];
            }
            break;
        case 15://退款/售后
            {
           
            }
            break;
        case 16://收货地址
            {
                AddressMangerController *vc = [[AddressMangerController alloc]init];
                [self navigatePushViewController:vc animate:YES];
            }
            break;
        case 17://银行卡
            {
                if([[UserModel sharedInstance].verifyStatus intValue] == 1)
                {
                    //获取银行卡信息
                    [self getBankCardInfo];
                }
                else
                {
                    [self showMessage:@"请先进行实名认证"];
                }
            }
            break;
        case 18://设置
            {
//                [self showMessage:@"努力开发中"];
                SetViewController *vc = [[SetViewController alloc]init];
                [self navigatePushViewController:vc animate:YES];

            }
            break;
            
        default:
            break;
    }
    
}

 
#pragma mark ------------------------Api----------------------------------
-(void)getUserInfo{
WEAK_SELF
//   [self showHub];
   [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"UserApi/userDetailsInformation" block:^(NSDictionary *resultDic, NSError *error) {
       NSLog(@"resultDic:%@",resultDic);
       [weak_self dissmiss];
       if ([resultDic[@"code"] integerValue]==200) {
           
           [weak_self.headerV.headerImg sd_SetImgWithUrlStr:resultDic[@"params"][@"avatar"]placeHolderImgName:@"my-header"];
           weak_self.headerV.phoneLabel.hidden = NO;
           weak_self.headerV.phoneLabel.text=[Util hidePhoneMiddle:resultDic[@"params"][@"mobile"]];
            [weak_self.headerV.loginBtn setTitle:resultDic[@"params"][@"nickName"] forState:UIControlStateNormal];
           weak_self.headerV.goodsNum.text = [NSString stringWithFormat:@"%@",resultDic[@"params"][@"followGoodsNumber"]];
           weak_self.headerV.storeNum.text = [NSString stringWithFormat:@"%@",resultDic[@"params"][@"followShopNumber"]];
           weak_self.headerV.recordsNum.text = [NSString stringWithFormat:@"%@",resultDic[@"params"][@"browseRecordsNumber"]];
           NSInteger percentage=30;
           
           if (!isEmpty(resultDic[@"params"][@"avatar"])) {
               percentage+=10;
           }
           if (!isEmpty(resultDic[@"params"][@"capacity"])) {
               percentage+=10;
           }
           if (!isEmpty(resultDic[@"params"][@"major"])) {
               percentage+=10;
           }
           if (!isEmpty(resultDic[@"params"][@"area"])) {
               percentage+=10;
           }
           if (!isEmpty(resultDic[@"params"][@"annexes"])) {
               percentage+=20;
           }
           if (!isEmpty(resultDic[@"params"][@"myself"])) {
               percentage+=10;
           }
           
            [weak_self.headerV.editBtn setTitle:[NSString stringWithFormat:@"   完善资料%ld%%   ",percentage] forState:UIControlStateNormal];
           
           [[UserModel sharedInstance].userInfo setValue:resultDic[@"params"][@"realNameVerifyState"] forKey:@"verifyStatus"];
           [[UserModel sharedInstance].userInfo setValue:resultDic[@"params"][@"truename"] forKey:@"truename"];
                      
           [[UserModel sharedInstance] saveUserInfo:[UserModel sharedInstance].userInfo];
           
           
           if([[UserModel sharedInstance].verifyStatus intValue] == 1)
           {
               [self.headerV.vertifyStatusBtn setTitle:@"已实名" forState:UIControlStateNormal];
           }else
           {
               [self.headerV.vertifyStatusBtn setTitle:@"去认证 >" forState:UIControlStateNormal];
           }
           
        }else{
           [weak_self showMessage:resultDic[@"desc"]];
       }
   }];
}

-(void)getBankCardInfo{
WEAK_SELF
   [self showHub];
   [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"UserApi/getBankCardInfo" block:^(NSDictionary *resultDic, NSError *error) {
       NSLog(@"resultDic:%@",resultDic);
       [weak_self dissmiss];
       if ([resultDic[@"code"] integerValue]== -200) {
           BanKCardViewController *vc = [[BanKCardViewController alloc] init];
           [weak_self navigatePushViewController:vc animate:YES];
       }
       else if([resultDic[@"code"] integerValue] == 200)
       {
           BankCardListViewController *vc = [[BankCardListViewController alloc] init];
           [weak_self navigatePushViewController:vc animate:YES];
       }
       else{
           [weak_self showMessage:resultDic[@"desc"]];
       }
   }];
}

 
#pragma mark ------------------------Getter / Setter----------------------
- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        _flowlayout = [[UICollectionViewFlowLayout alloc] init];
       
        [_flowlayout setHeaderReferenceSize:CGSizeMake(kScreenWidth, 247)];
        _flowlayout.sectionInset = UIEdgeInsetsMake(0, 0, 0,0);
        _flowlayout.minimumInteritemSpacing = 0;
        _flowlayout.minimumLineSpacing = 0;
        _flowlayout.itemSize = CGSizeMake(kScreenWidth,230);
        _collectionView.alwaysBounceVertical = YES;
        //设置滚动方向
        [_flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarAndTabBarHeight)  collectionViewLayout:_flowlayout];
        _collectionView.backgroundColor = KViewBgColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"MeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MeCollectionViewCell"];
 
        //注册头
        [_collectionView registerNib:[UINib nibWithNibName:@"MeHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MeHeaderView"];
    }
    return _collectionView;
}

@end
