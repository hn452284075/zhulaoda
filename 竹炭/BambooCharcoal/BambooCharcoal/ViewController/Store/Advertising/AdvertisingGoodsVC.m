//
//  AdvertisingGoodsVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/3.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "AdvertisingGoodsVC.h"
#import "MycommonTableView.h"
#import "AdvertisingGoodsCell.h"
#import "SetAdvertisingVC.h"

@interface AdvertisingGoodsVC ()
@property (nonatomic,strong)MycommonTableView *listTableView;
@property (nonatomic,strong)NSString *beenSetNumber;
@property (nonatomic,strong)NSString *notSetGoodsNumber;
@end

@implementation AdvertisingGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.pageTitle=@"广告位商品";
    self.view.backgroundColor=KViewBgColor;
    [self.view addSubview:self.listTableView];
    
    [self removeLine];
    
 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self _requestOrderData];
}

//没有数据的时候
- (void)_initViewNoData
{
    for (UIView *view in self.view.subviews) {
        if (view.tag==1) {
            [view removeFromSuperview];
        }
    }
    
    UIImageView *iconImgview = [[UIImageView alloc] init];
    iconImgview.tag=1;
//    iconImgview.image
    [self.view addSubview:iconImgview];
    [iconImgview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(92);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@106);
        make.height.equalTo(@106);
    }];
    
    UILabel *msglab = [[UILabel alloc] init];
    msglab.tag=1;
    [self.view addSubview:msglab];
    [msglab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImgview.mas_bottom).offset(46);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kScreenWidth);
        make.height.equalTo(@16);
    }];
    msglab.textAlignment = NSTextAlignmentCenter;
    msglab.font = CUSTOMFONT(16);
    msglab.textColor = UIColorFromRGB(0x001212);
    msglab.text = @"您还没有设置广告位商品";
    
    UIButton *btn = [[UIButton alloc] init];
    btn.tag=1;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(msglab.mas_bottom).offset(28);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(125);
        make.height.equalTo(@40);
    }];
    btn.layer.cornerRadius = 20.;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = UIColorFromRGB(0x46c67c);
    [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [btn setTitle:@"立即设置" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
}




-(void)initTopView{
    
    for (UIView *view in self.view.subviews) {
        if (view.tag==2) {
            [view removeFromSuperview];
        }
    }
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    topView.tag=2;
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, kScreenWidth, 16)];
    titleLabel.tag=2;
    titleLabel.textAlignment=0;
    titleLabel.font=CUSTOMFONT(12);
    NSString *s1 = self.beenSetNumber;
     NSString *s2=self.notSetGoodsNumber;
     NSString *str2 = [NSString stringWithFormat:@"已设置广告位商品%@个还可以设置%@个",s1,s2];
     
     // 创建Attributed
     NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:str2];
     // 改变颜色
     [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(8,s1.length)];
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(s1.length+14,s2.length)];
     
     [noteStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x666666) range:NSMakeRange(0,0)];
     
     titleLabel.attributedText = noteStr;
    [topView addSubview:titleLabel];
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    setBtn.tag=2;
    setBtn.frame = CGRectMake(kScreenWidth-51-14, 9, 51, 24);
    [setBtn setTitle:@"设置" forState:UIControlStateNormal];
    setBtn.titleLabel.font=CUSTOMFONT(12);
    [setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [setBtn setBackgroundColor:KCOLOR_Main];
    setBtn.layer.cornerRadius=12;
    [topView addSubview:setBtn];
}

-(void)setBtnClick{
    
    SetAdvertisingVC *vc = [[SetAdvertisingVC alloc]init];
    [self navigatePushViewController:vc animate:YES];

}
-(void)_requestOrderData{
        NSDictionary *param = @{kRequestPageNumKey :@(self.listTableView.dataLogicModule.requestFromPage),kRequestPageSizeKey:@(kRequestDefaultPageSize)};
        WEAK_SELF
        [self showHub];
        [AFNHttpRequestOPManager postWithParameters:param subUrl:@"SupplyApi/selectHorseBusinessAdvertisingGoodsList" block:^(NSDictionary *resultDic, NSError *error) {
            [weak_self dissmiss];
            NSLog(@"resultDic:%@",resultDic);
            if ([resultDic[@"code"] integerValue]==200) {
                weak_self.beenSetNumber = [NSString stringWithFormat:@"%@",resultDic[@"params"][@"beenSetNumber"]];
                weak_self.notSetGoodsNumber = [NSString stringWithFormat:@"%@",resultDic[@"params"][@"notSetGoodsNumber"]];
                [weak_self initTopView];
                
//                if (isEmpty(resultDic[@"params"][@"beenSetGoodsList"])) {
////                    [weak_self _initViewNoData];
//                }else{
//                    for (UIView *view in weak_self.view.subviews) {
//                          if (view.tag==1) {
//                              [view removeFromSuperview];
//                          }
//                    }
//
//                }
                [weak_self.listTableView configureTableAfterRequestPagingData:resultDic[@"params"][@"beenSetGoodsList"]];

            }else{
                [weak_self showMessage:[NSString isEmptyForString:resultDic[@"desc"]]];
            }
            
        }];
    
    
}

-(void)cancel:(NSString *)goodsId{
    WEAK_SELF
   [self showHub];
   NSDictionary *param = @{@"goodsIds":goodsId};
   [AFNHttpRequestOPManager postWithParameters:param subUrl:@"SupplyApi/cancelHorseBusinessAdvertisingGoods" block:^(NSDictionary *resultDic, NSError *error) {
       [weak_self dissmiss];
       NSLog(@"resultDic:%@",resultDic);
       if ([resultDic[@"code"] integerValue]==200) {
           [weak_self showSuccessInfoWithStatus:resultDic[@"params"][@"desc"]];
            weak_self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
          weak_self.listTableView.dataLogicModule.requestFromPage=1;
          [weak_self _requestOrderData];
           
       }else{
           [weak_self showMessage:resultDic[@"desc"]];
       }
       
   }];
      
       
}

- (MycommonTableView *)listTableView{
    
    if (!_listTableView) {
        _listTableView  = [[MycommonTableView alloc]initWithFrame:CGRectMake(0, 52, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-52) style:UITableViewStylePlain];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.backgroundColor = KViewBgColor;
        _listTableView.cellHeight = 108.0f;
        _listTableView.noDataLogicModule.nodataAlertTitle=@"您还没有设置广告位商品";
        WEAK_SELF
        [_listTableView configurecellNibName:@"AdvertisingGoodsCell" configurecellData:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSUInteger index) {
            NSDictionary *dic = (NSDictionary *)cellModel;
            AdvertisingGoodsCell *orderCell =(AdvertisingGoodsCell *)cell;
            orderCell.price.text = [NSString stringWithFormat:@"%@",dic[@"goodsPrice"]];
            orderCell.goodsName.text = dic[@"goodsName"];
            orderCell.unit.text = [NSString stringWithFormat:@"/%@",dic[@"unit"]];
            [orderCell.goodsImage sd_SetImgWithUrlStr:dic[@"picUrl"] placeHolderImgName:nil];
            [orderCell.cancelBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                [weak_self cancel:dic[@"goodsId"]];
            }];
            orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSLog(@"%@",cellModel);
            
            
            
            
        } clickCell:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSIndexPath *clickIndexPath) {
            
            
        }];
        
        
        [_listTableView headerRreshRequestBlock:^{
            weak_self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
            weak_self.listTableView.dataLogicModule.requestFromPage=1;
            [weak_self _requestOrderData];
        }];
        
        
        [_listTableView footerRreshRequestBlock:^{
            [weak_self _requestOrderData];
            
        }];
        
        
        
    }
    
    return _listTableView;
}

@end
