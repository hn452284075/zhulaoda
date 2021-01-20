//
//  BuyHallVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/5.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BuyHallVC.h"
#import "UIView+Frame.h"
#import "MycommonTableView.h"
#import "BuyHallCell.h"
#import "BuyHallHeaderView.h"
#import "SearchGoodsVC.h"
#import "MyShoppingCell.h"
#import "BuyHallSearchVC.h"
#import "EndProcurementVC.h"
#import "PublishProcurementVC.h"
#import "ClassGoodsVC.h"
#import "BuyHallInfoViewController.h"
#import "GoodsCategoryModel.h"

@interface BuyHallVC ()<UITableViewDelegate,UITableViewDataSource,PublishProcurementVCDelegate>
{
    UIButton *buyBtn;
    UIButton *procurementBtn;
    UIButton *addBtn;
}
@property (nonatomic,strong)MycommonTableView *listTableView;
@property (nonatomic,strong)BuyHallHeaderView *header;
@property (nonatomic,strong)UIImageView *topBgView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *class_arr_1;

@end

@implementation BuyHallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getCategoryInfo];  //解析首页传过来的分类
    
    [self _initTopView];
    [self _initUI];

}

-(UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}

 

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeLine];
     self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xFFB300);
}
#pragma mark ------------------------Init---------------------------------
-(void)_initTopView{
    
    [self setLeftWhileArrow];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
    self.navigationItem.titleView = topView;
    
    buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn.frame = CGRectMake(22, 0, 70, 25);
    [buyBtn setTitle:@"求购大厅" forState:UIControlStateNormal];
    buyBtn.titleLabel.font=CUSTOMFONT(16);
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buyBtn addTarget:self action:@selector(buyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.selected=YES;
    [topView addSubview:buyBtn];
    
    procurementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    procurementBtn.frame = CGRectMake(buyBtn.right+16, 0, 70, 25);
    [procurementBtn setTitle:@"我的采购" forState:UIControlStateNormal];
    procurementBtn.titleLabel.font=CUSTOMFONT(14);
    [procurementBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [procurementBtn addTarget:self action:@selector(procurementBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:procurementBtn];
    
}
-(void)_initUI{
    self.view.backgroundColor =KViewBgColor;
    _topBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1, kScreenWidth, 101)];
    [_topBgView setImage:IMAGE(@"qiugou-hbj")];
    _topBgView.hidden=YES;
    [self.view addSubview:_topBgView];
    [self _requestOrderData];
}
-(void)_initTableView{
     [self.view addSubview:self.listTableView];
    if (!addBtn) {
        addBtn  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addBtn.frame = CGRectMake(kScreenWidth-70-14, kScreenHeight-kStatusBarAndNavigationBarHeight-70-22-14, 70, 70);
        [addBtn setTitle:@"发采购" forState:UIControlStateNormal];
        addBtn.titleLabel.font=CUSTOMFONT(17);
        [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setBackgroundColor:UIColorFromRGB(0xFFB300)];
        addBtn.layer.cornerRadius=35;
        [self.view addSubview:addBtn];
    }
    [self.view bringSubviewToFront:addBtn];

}
#pragma mark ------------------------Private-------------------------
-(void)_refresh{
    self.listTableView.dataLogicModule.currentDataModelArr = @[].mutableCopy;
    self.listTableView.dataLogicModule.requestFromPage=1;
    
}
-(void)buyBtnClick{
    buyBtn.selected=!buyBtn.selected;
    if (buyBtn.selected) {
        _listTableView.noDataLogicModule.needDealNodataCondition=NO;
        
        procurementBtn.titleLabel.font=CUSTOMFONT(14);
        procurementBtn.selected=NO;
        buyBtn.titleLabel.font=CUSTOMBOLDFONT(16);
        self.topBgView.hidden=YES;
        [self _refresh];
        [self _requestOrderData];
        
    }
    
}
-(void)procurementBtnClick{
    procurementBtn.selected=!procurementBtn.selected;
       if (procurementBtn.selected) {
           _listTableView.noDataLogicModule.needDealNodataCondition=YES;
           buyBtn.selected=NO;
           self.topBgView.hidden=NO;
           buyBtn.titleLabel.font=CUSTOMFONT(14);
           procurementBtn.titleLabel.font=CUSTOMBOLDFONT(16);
           [self _refresh];
           [self _requestMyPurchaseData];
       }
}

 
- (void)getCategoryInfo
{
    self.class_arr_1 = [[NSMutableArray alloc] init];
    for(int i=0;i<self.categoryArray.count;i++)
    {
        GoodsCategoryModel *model = [self.categoryArray objectAtIndex:i];
        NSMutableArray *temparr = [[NSMutableArray alloc] init];
        if(model.hasSubCategory == 1)
        {
            NSArray *model_sub_arr = model.subCateGory;
            for(int j=0;j<model_sub_arr.count;j++)
            {
                if(temparr.count == 9)
                {
                    [temparr addObject:@"查看更多"];
                }
                else if(temparr.count == 10){
                    continue;
                }
                [temparr addObject:model_sub_arr[j]];
            }
        }
        if(i == 0)
        {
            self.class_arr_1 = temparr;
        }
    }
}
 



#pragma mark ------------------------Api----------------------------------
-(void)_requestOrderData{
    WEAK_SELF
    [self showHub];
    NSDictionary *param = @{kRequestPageNumKey :@(self.listTableView.dataLogicModule.requestFromPage),kRequestPageSizeKey:@(kRequestDefaultPageSize)};
    [AFNHttpRequestOPManager postBodyParameters:param subUrl:@"PurchaseApi/purchaseSearch" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            dispatch_async(dispatch_get_main_queue(), ^{                
              [weak_self _initTableView];
              if(isEmpty(resultDic[@"params"]))
                  return;
              [weak_self.listTableView configureTableAfterRequestPagingData:resultDic[@"params"][@"records"]];
            });
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
        
    }];
}

-(void)_requestMyPurchaseData{
    WEAK_SELF
    [self showHub];
    NSDictionary *param = @{kRequestPageNumKey :@(self.listTableView.dataLogicModule.requestFromPage),kRequestPageSizeKey:@(kRequestDefaultPageSize),@"status":@"0"};
    [AFNHttpRequestOPManager postWithParameters:param subUrl:@"PurchaseApi/myPurchaseByPage" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            dispatch_async(dispatch_get_main_queue(), ^{
              
              [weak_self.listTableView configureTableAfterRequestPagingData:resultDic[@"params"][@"myPurchaseVos"]];
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weak_self.listTableView configureTableAfterRequestPagingData:@[]];
                [weak_self.listTableView reloadData];
            });
            [weak_self showMessage:resultDic[@"desc"]];
        }
        
    }];
}

#pragma mark ------------------------Page Navigate---------------------------
 
-(void)jumpSearchVC{
    BuyHallSearchVC *vc = [[BuyHallSearchVC alloc]init];
    [self navigatePushViewController:vc animate:YES];

}
-(void)jumpEndProcurementVC{
    EndProcurementVC *vc = [[EndProcurementVC alloc]init];
    [self navigatePushViewController:vc animate:YES];

}
-(void)addBtnClick{
    
    if (!UserIsLogin) {
        [self _jumpLoginPage];
        return;
    }
    if([[UserModel sharedInstance].verifyStatus intValue] == 1)
    {
        PublishProcurementVC *vc = [[PublishProcurementVC alloc]init];
        vc.delegate = self;
        [self navigatePushViewController:vc animate:YES];
    }
    else
    {
        [self showMessage:@"请先实名认证"];
    }
}
-(void)jumpClassGoodsVC:(int)cateId name:(NSString *)catename{
    ClassGoodsVC *vc = [[ClassGoodsVC alloc]init];
    vc.categoryArray = self.categoryArray;
    vc.currentCategoryId = (int)cateId;
    vc.currentCateName = catename;
    vc.jumpFlagValue = 2;
    [self navigatePushViewController:vc animate:YES];

}
#pragma mark ------------------------View Event---------------------------

#pragma mark ------------------------Delegate-----------------------------
- (void)publishProcurementSuccess
{
    [self _refresh];
    [self _requestOrderData];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (buyBtn.selected) {
    return 238;
    }

    return 60;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (buyBtn.selected) {
         _header=BoundNibView(@"BuyHallHeaderView", BuyHallHeaderView);
        //        _header.frame=CGRectMake(0, 0, kScreenWidth, 238);
        NSLog(@"%@",NSStringFromCGRect(_header.frame));
        WEAK_SELF
        [_header.searchBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self jumpSearchVC];
        }];
        [_header.allClassBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self jumpClassGoodsVC:-1 name:@"全部"];
        }];
        
        if(self.class_arr_1.count == 5)
        {
            NSDictionary *m1 = [self.class_arr_1 objectAtIndex:0];
            NSDictionary *m2 = [self.class_arr_1 objectAtIndex:1];
            NSDictionary *m3 = [self.class_arr_1 objectAtIndex:2];
            NSDictionary *m4 = [self.class_arr_1 objectAtIndex:3];
            NSDictionary *m5 = [self.class_arr_1 objectAtIndex:4];
            [_header.itemBtn1 sd_setImageWithURL:[NSURL URLWithString:m1[@"iconUrl"]]];
            _header.itemBtn1.tag = [m1[@"cateGoryId"] intValue];
            _header.itemLab1.text = m1[@"cateGoryName"];
            [_header.itemBtn2 sd_setImageWithURL:[NSURL URLWithString:m2[@"iconUrl"]]];
            _header.itemBtn2.tag = [m2[@"cateGoryId"] intValue];
            _header.itemLab2.text = m2[@"cateGoryName"];
            [_header.itemBtn3 sd_setImageWithURL:[NSURL URLWithString:m3[@"iconUrl"]]];
            _header.itemBtn3.tag = [m3[@"cateGoryId"] intValue];
            _header.itemLab3.text = m3[@"cateGoryName"];
            [_header.itemBtn4 sd_setImageWithURL:[NSURL URLWithString:m4[@"iconUrl"]]];
            _header.itemBtn4.tag = [m4[@"cateGoryId"] intValue];
            _header.itemLab4.text = m4[@"cateGoryName"];
            [_header.itemBtn5 sd_setImageWithURL:[NSURL URLWithString:m5[@"iconUrl"]]];
            _header.itemBtn5.tag = [m5[@"cateGoryId"] intValue];
            _header.itemLab5.text = m5[@"cateGoryName"];
        }
        
        _header.itemBtn1.userInteractionEnabled = YES;
        _header.itemBtn2.userInteractionEnabled = YES;
        _header.itemBtn3.userInteractionEnabled = YES;
        _header.itemBtn4.userInteractionEnabled = YES;
        _header.itemBtn5.userInteractionEnabled = YES;
        
        [_header.itemBtn1 addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self jumpClassGoodsVC:(int)weak_self.header.itemBtn1.tag name:weak_self.header.itemLab1.text];
        }];
        [_header.itemBtn2 addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self jumpClassGoodsVC:(int)weak_self.header.itemBtn2.tag name:weak_self.header.itemLab2.text];
        }];
        [_header.itemBtn3 addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self jumpClassGoodsVC:(int)weak_self.header.itemBtn3.tag name:weak_self.header.itemLab3.text];
        }];
        [_header.itemBtn4 addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self jumpClassGoodsVC:(int)weak_self.header.itemBtn4.tag name:weak_self.header.itemLab4.text];
        }];
        [_header.itemBtn5 addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self jumpClassGoodsVC:(int)weak_self.header.itemBtn5.tag name:weak_self.header.itemLab5.text];
        }];
        
    return self.header;
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    WEAK_SELF
    [headerView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weak_self jumpEndProcurementVC];
    }];
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(14, 5, kScreenWidth-28, 46)];
    subView.layer.cornerRadius=5;
    subView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:subView];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 15, 50, 16)];
    titleLabel.textColor = UIColorFromRGB(0x222222);
    titleLabel.textAlignment=1;
    titleLabel.text = @"已结束";
    titleLabel.font=CUSTOMFONT(15);
    [subView addSubview:titleLabel];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(kScreenWidth-50-30-15, 13, 50, 20);
    [leftBtn setTitle:@"0" forState:UIControlStateNormal];
    [leftBtn setImage:IMAGE(@"rightArrow") forState:UIControlStateNormal];
    leftBtn.titleLabel.font=CUSTOMFONT(14);
    [leftBtn setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];

    leftBtn.imageEdgeInsets=UIEdgeInsetsMake(0, 40, 0, 0);
    [subView addSubview:leftBtn];
    
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (buyBtn.selected) {
    return 165;
    }
    return 172;
}
-(UIView  *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.00000001f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.listTableView.dataLogicModule.currentDataModelArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
     if (!buyBtn.selected) {
         return;
     }
    BuyHallInfoViewController *vc = [[BuyHallInfoViewController alloc] init];
    NSDictionary *dic = self.listTableView.dataLogicModule.currentDataModelArr[indexPath.row];
    vc.hallId = dic[@"id"];
    [self navigatePushViewController:vc animate:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (buyBtn.selected) {
        BuyHallCell *cell = [self.listTableView dequeueReusableCellWithIdentifier:@"BuyHallCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.listTableView.dataLogicModule.currentDataModelArr.count>0) {
            NSDictionary *dic = self.listTableView.dataLogicModule.currentDataModelArr[indexPath.row];
            [cell setDic:dic];
        }
        
        return cell;
    }
    MyShoppingCell *cell = [self.listTableView dequeueReusableCellWithIdentifier:@"MyShoppingCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.listTableView.dataLogicModule.currentDataModelArr[indexPath.row];
    [cell setDic:dic];
    return cell;
 
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyHallCell *buyCell;
    MyShoppingCell *shopCell;
    if (buyBtn.selected) {
     buyCell = (BuyHallCell *)cell;
    }else{
     shopCell= (MyShoppingCell *)cell;
    }
    
  
   //判断当前只有一个cell
    if ([tableView numberOfRowsInSection:indexPath.section] == 1 && indexPath.row == 0) {
        //只有一个cell的时候进入
        if (buyBtn.selected) {
            buyCell.bgView.layer.masksToBounds = YES;
            buyCell.bgView.layer.cornerRadius = 8;
        }else{
            shopCell.bgView.layer.masksToBounds = YES;
            shopCell.bgView.layer.cornerRadius = 8;
        }
      
    }else{
        //刷新cell的时候把第一个圆角恢复
        if (buyBtn.selected) {
            buyCell.bgView.layer.masksToBounds = YES;
            buyCell.bgView.layer.cornerRadius = 0;
        }else{
            shopCell.bgView.layer.masksToBounds = YES;
            shopCell.bgView.layer.cornerRadius = 0;
        }
        
        if ([buyCell.bgView respondsToSelector:@selector(tintColor)]||[shopCell.bgView respondsToSelector:@selector(tintColor)]) {
            if (tableView == self.listTableView) {
                // 圆角弧度半径
                CGFloat cornerRadius = 8.f;
                // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
                CGRect bounds;
                if (buyBtn.selected) {
                buyCell.bgView.backgroundColor = UIColor.clearColor;
                bounds = CGRectInset(CGRectMake(14, 0, kScreenWidth-28, 165), 0, 0);
                }else{
                shopCell.bgView.backgroundColor = UIColor.clearColor;
                bounds = CGRectInset(CGRectMake(14, 0, kScreenWidth-28, 171), 0, 0);
                }
                // 创建一个shapeLayer
                CAShapeLayer *layer = [[CAShapeLayer alloc] init];
                CAShapeLayer *backgroundLayer = [[CAShapeLayer alloc] init]; //显示选中
                // 创建一个可变的图像Path句柄，该路径用于保存绘图信息
                CGMutablePathRef pathRef = CGPathCreateMutable();
 
                // 这里要判断分组列表中的第一行，每组section的第一行，每组section的中间行
                BOOL addLine = NO;
                // CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
                if (indexPath.row == 0) {
                    // 初始起点为cell的左下角坐标
                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                    // 起始坐标为左下角，设为p1，（CGRectGetMinX(bounds), CGRectGetMinY(bounds)）为左上角的点，设为p1(x1,y1)，(CGRectGetMidX(bounds), CGRectGetMinY(bounds))为顶部中点的点，设为p2(x2,y2)。然后连接p1和p2为一条直线l1，连接初始点p到p1成一条直线l，则在两条直线相交处绘制弧度为r的圆角。
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                    // 终点坐标为右下角坐标点，把绘图信息都放到路径中去,根据这些路径就构成了一块区域了
                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                    addLine = YES;
                }
                else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                    // 初始起点为cell的左上角坐标
                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                    // 添加一条直线，终点坐标为右下角坐标点并放到路径中去
                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
                }
                else
                {
                    // 添加cell的rectangle信息到path中（不包括圆角）
                    CGPathAddRect(pathRef, nil, bounds);
                    addLine = YES;
                }


                // 把已经绘制好的可变图像路径赋值给图层，然后图层根据这图像path进行图像渲染render
                layer.path = pathRef;
                backgroundLayer.path = pathRef;
                // 注意：但凡通过Quartz2D中带有creat/copy/retain方法创建出来的值都必须要释放
                CFRelease(pathRef);
                // 按照shape layer的path填充颜色，类似于渲染render
                // layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
                layer.fillColor = [UIColor whiteColor].CGColor;
//                // 添加分隔线图层
//                if (addLine == YES) {
//                    CALayer *lineLayer = [[CALayer alloc] init];
//                    CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
//                    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
//                    // 分隔线颜色取自于原来tableview的分隔线颜色
//                    lineLayer.backgroundColor = tableView.separatorColor.CGColor;
//                    [layer addSublayer:lineLayer];
//                }
                UIView *roundView;
                if (buyBtn.selected) {
                    // view大小与cell一致
                   roundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 165)];
                   // 添加自定义圆角后的图层到roundView中
                   [roundView.layer insertSublayer:layer atIndex:0];
                   roundView.backgroundColor = UIColor.clearColor;
                   //cell的背景view
                   //cell.selectedBackgroundView = roundView;
                   buyCell.backgroundView = roundView;
                    
//                   //以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
//                   UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
//                   backgroundLayer.fillColor = tableView.separatorColor.CGColor;
//                   [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
//                   selectedBackgroundView.backgroundColor = UIColor.clearColor;
//                   buyCell.selectedBackgroundView = selectedBackgroundView;
                }else{
                  roundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 165)];
                  // 添加自定义圆角后的图层到roundView中
                  [roundView.layer insertSublayer:layer atIndex:0];
                  roundView.backgroundColor = UIColor.clearColor;
                  shopCell.backgroundView = roundView;
                }
               
            }
        }
    }

}
#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------
- (MycommonTableView *)listTableView{
    
    
    if (!_listTableView) {
        
        
        _listTableView  = [[MycommonTableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:UITableViewStyleGrouped];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.backgroundColor = [UIColor clearColor];
        _listTableView.delegate=self;
        _listTableView.dataSource=self;
        [_listTableView registerNib:[UINib nibWithNibName:@"BuyHallCell" bundle:nil] forCellReuseIdentifier:@"BuyHallCell"];
        [_listTableView registerNib:[UINib nibWithNibName:@"MyShoppingCell" bundle:nil] forCellReuseIdentifier:@"MyShoppingCell"];

       
        
        WEAK_SELF
        [_listTableView headerRreshRequestBlock:^{
            [weak_self _refresh];
            if (self->buyBtn.selected) {
                 [self _requestOrderData];
             }else{
                 [self _requestMyPurchaseData];
             }
            
        }];
        
        
        [_listTableView footerRreshRequestBlock:^{
             if (self->buyBtn.selected) {
                    [self _requestOrderData];
             }else{
                    [self _requestMyPurchaseData];
             }
            
        }];
        
    }
    
    return _listTableView;
}



 
@end
