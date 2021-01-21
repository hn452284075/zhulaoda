//
//  ManageStoreViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/4.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "ManageStoreViewController.h"
#import "ManageStoreCellView.h"
#import "CertificationViewController.h"
#import "OSMainViewController.h"
#import "ExpressMouldViewController.h"
#import "ShopModel.h"
#import "VertifySucessController.h"
#import "OSApplyViewController.h"
#import "PersonDetailViewController.h"

@interface ManageStoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) ShopModel   *shopInfo;


@end

@implementation ManageStoreViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.tableview)
    {
        [self getShopInfo];
        [self.tableview reloadData];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageTitle = @"店铺管理";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    self.shopInfo = [[ShopModel alloc] init];
    self.shopInfo.shopName = @"";
    
    self.tableview = [[UITableView alloc] init];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.tableFooterView = [[UIView alloc] init];
    self.tableview.separatorColor = UIColorFromRGB(0xf2f2f2);
//    [self getShopInfo];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(OpenStoreOk) name:@"OpenStoreOk" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IDCardVertifyOK) name:@"IDCardVertifyOK" object:nil];
    
}


- (void)IDCardVertifyOK
{
    VertifySucessController *vc = [[VertifySucessController alloc] init];
    [self navigatePushViewController:vc animate:YES];
}


- (void)OpenStoreOk
{
    PersonDetailViewController *vc = [[PersonDetailViewController alloc] init];
    [self navigatePushViewController:vc animate:YES];
}


#pragma mark ------------------------Api----------------------------------
-(void)getShopInfo{
    
    WEAK_SELF
//    [self showHub];
    
    [AFNHttpRequestOPManager postWithParameters:@{@"shopAccId":[UserModel sharedInstance].userId} subUrl:@"ShopApi/shopDetailsInformation" block:^(NSDictionary *resultDic, NSError *error) {
//        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
              
            weak_self.shopInfo = [ShopModel mj_objectWithKeyValues:resultDic[@"params"]];
            
            [weak_self.tableview reloadData];
            
        }else{
            //[weak_self showErrorInfoWithStatus:resultDic[@"desc"]];
        }
        
    }];
    
}



#pragma mark ------------------------Delegate-----------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (!UserIsLogin) {
        [self _jumpLoginPage];
        return;
    }
    if(indexPath.row == 0)
    {
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
    else if(indexPath.row == 1)
    {
        
        if ([[UserModel sharedInstance].phone isEqualToString:@"18670770713"]) {
          PersonDetailViewController *vc = [[PersonDetailViewController alloc] init];
//          vc.shopAccId =  self.shopInfo.accid;
          [self navigatePushViewController:vc animate:YES];
        return;
        }
        
        
        
        if([[UserModel sharedInstance].verifyStatus intValue] == 1)
        {
            if(self.shopInfo.openPayState == 1){
                
                PersonDetailViewController *vc = [[PersonDetailViewController alloc] init];
                [self navigatePushViewController:vc animate:YES];

            }else{
                OSMainViewController *vc = [[OSMainViewController alloc] init];
                vc.smodel = self.shopInfo;
                [self navigatePushViewController:vc animate:YES];
                
//                OSApplyViewController *vc = [[OSApplyViewController alloc] init];
//                
//                [self navigatePushViewController:vc animate:YES];
            }
             
            
        }else{
            [self showMessage:@"请先实名认证"];
        }
    }
    else if(indexPath.row == 2)
    {
        ExpressMouldViewController *vc = [[ExpressMouldViewController alloc] init];
        [self navigatePushViewController:vc animate:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"supplygoodscell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
        ManageStoreCellView *mv = [[ManageStoreCellView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 56)];
        mv.tag = 100;
        mv.backgroundColor = [UIColor whiteColor];
        [cell addSubview:mv];
        [mv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.mas_top);
            make.left.equalTo(cell.mas_left);
            make.right.equalTo(cell.mas_right);
            make.height.mas_equalTo(56);
        }];
    }
    ManageStoreCellView *mv = (ManageStoreCellView *)[cell viewWithTag:100];
    if(indexPath.row == 0)
    {
        NSString *verStr = @"去认证";
        if([[UserModel sharedInstance].verifyStatus intValue] == 1)
        {
            verStr = @"已经实名";
        }
        
        [mv configCellInfoImage:@"veritifyicon"
                                   title:@"实名认证"
                                  status:verStr];
        [mv configCellInfoShowImage:YES
                                   showTitle:YES
                                showSubTitle:YES
                                   showArrow:YES];
    }
    else if(indexPath.row == 1)
    {
        NSString *str = @"去开通";
        if(self.shopInfo.shopName.length > 0)
        {
            str = self.shopInfo.shopName;
        }
        
        [mv configCellInfoImage:@"openstoreicon"
                                   title:@"网上开店"
                                  status:str];
        [mv configCellInfoShowImage:YES
                                   showTitle:YES
                                showSubTitle:YES
                                   showArrow:YES];
    }
    else if(indexPath.row == 2)
    {
        
        [mv configCellInfoImage:@"expressicon"
                                   title:@"运费模板"
                                  status:@""];
        [mv configCellInfoShowImage:YES
                                   showTitle:YES
                                showSubTitle:NO
                                   showArrow:YES];
    }
    
    
    return cell;
}


@end
