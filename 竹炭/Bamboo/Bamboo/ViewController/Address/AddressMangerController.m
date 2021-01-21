//
//  AddressMangerController.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/8/26.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "AddressMangerController.h"
#import "MycommonTableView.h"
#import "AddressMangerCell.h"
#import "ZZAddressController.h"

#import "UserAddressModel.h"
#import "AddressMangerCell.h"



@interface AddressMangerController ()<ZZAddressDelegate,MannageAddressDelegate>
 
@property (nonatomic,strong)MycommonTableView *addressTable;
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic, strong)UIButton *goBtn;
@end

@implementation AddressMangerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageTitle = @"收货地址";
     
    [self _initaddressTable];
    [self addBottomView];
    [self getAllUserAddress];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark ------------------------Init---------------------------------
- (void)_initaddressTable {
    
    self.addressTable=[[MycommonTableView alloc]initWithFrame:CGRectMake(0, 0.5, kScreenWidth, kScreenHeight)];
    self.addressTable.cellHeight = 79;
    self.addressTable.noDataLogicModule.nodataAlertTitle=@"您还没有收货地址噢";
    self.addressTable.noDataLogicModule.nodataAlertImage=@"addressDefault";
    self.addressTable.noDataLogicModule.nodataBgColor =KViewBgColor;
    self.addressTable.backgroundColor = KViewBgColor;
    WEAK_SELF
    [self.addressTable configurecellNibName:@"AddressMangerCell" configurecellData:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSUInteger index) {
        AddressMangerCell *_cell = (AddressMangerCell *)cell;
        _cell.delegate = self;
        cell.tag = index;
        [_cell configData:(UserAddressModel *)cellModel];
        
    }clickCell:^(UITableView *tableView, id cellModel, UITableViewCell *cell, NSIndexPath *clickIndexPath) {
        
        emptyBlock(weak_self.addressBlock,(UserAddressModel *)cellModel);
        [weak_self goBack];
    }];
    
    [self.view addSubview:self.addressTable];
 
}

-(void)addBottomView{
 
    
    //添加收货地址
    WEAK_SELF
    self.goBtn = [[UIButton alloc] init];
    self.goBtn.hidden=YES;
    [self.view addSubview:self.goBtn];
    [self.goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weak_self.view.mas_bottom).offset(-35);
        make.left.equalTo(weak_self.view.mas_left).offset(BtnLeftRightGap);
        make.right.equalTo(weak_self.view.mas_right).offset(-BtnLeftRightGap);
        make.height.mas_equalTo(45);
    }];
    [self factory_btn:self.goBtn
           backColor:KCOLOR_Main
           textColor:[UIColor whiteColor]
         borderColor:KCOLOR_Main
               title:@"添加收货地址"
            fontsize:16
              corner:22
                 tag:2];
    
     
}

-(void)addBtnClick:(id)sender{
    ZZAddressController *vc = [[ZZAddressController alloc]init];
    vc.delegate = self;
    [self navigatePushViewController:vc animate:YES];

}

- (void)factory_btn:(UIButton *)btn backColor:(UIColor *)bcolor textColor:(UIColor *)tcolor borderColor:(UIColor *)dcolor title:(NSString *)title fontsize:(int)fsize corner:(float)csize
                tag:(int)tag;
{
    btn.backgroundColor = bcolor;
    btn.layer.borderColor = dcolor.CGColor;
    [btn setTitleColor:tcolor forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.;
    btn.layer.cornerRadius = csize;
    btn.titleLabel.font = CUSTOMFONT(fsize);
    [btn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.tag = tag;
}


#pragma mark ------------------------Api----------------------------------
#pragma mark -------- 获取所有地址
- (void)getAllUserAddress
{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"userAddress/pageList" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        if ([resultDic[@"code"] integerValue]==200)
        {
            self.data = [[NSMutableArray alloc] init];
            NSArray *_tempArr = resultDic[@"params"][@"records"];
            for(int i=0;i<_tempArr.count;i++)
            {
                NSDictionary *_dic = [_tempArr objectAtIndex:i];
                UserAddressModel *mm = [[UserAddressModel alloc] init];
                mm.name = _dic[@"receiverName"];
                mm.phone = _dic[@"mobile"];
                mm.district = _dic[@"addressPrefix"];
                mm.detail_district = _dic[@"addressDetail"];
                mm.isDefault = [NSString stringWithFormat:@"%d",[_dic[@"isDefault"] intValue]];
                
                mm.detail_district = _dic[@"addressSuffix"];
                mm.isDefault = [NSString stringWithFormat:@"%d",[_dic[@"isDefault"] intValue]];
                mm.ad_id = [_dic[@"id"] intValue];
                [weak_self.data addObject:mm];
            }

            [weak_self.addressTable configureTableAfterRequestPagingData:weak_self.data];
            if (weak_self.data.count==0) {
                UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
               addBtn.frame = CGRectMake(kScreenWidth/2-75, kScreenHeight/2+50, 150, 42);
               [addBtn setTitle:@"创建地址" forState:UIControlStateNormal];
               addBtn.titleLabel.font=CUSTOMFONT(19);
               [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                addBtn.tag=10;
               [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
               [addBtn setBackgroundColor:KCOLOR_Main];
               addBtn.layer.cornerRadius=21;
               [weak_self.view addSubview:addBtn];
                weak_self.goBtn.hidden=YES;
                weak_self.addressTable.scrollEnabled=NO;
            }else{
                for (UIView *view in self.view.subviews) {
                    if(view.tag==10){
                        [view removeFromSuperview];
                    }
                }
                weak_self.addressTable.scrollEnabled=YES;
                weak_self.goBtn.hidden=NO;
            }
           
            
        }else{
           
            [weak_self showMessage:resultDic[@"desc"]];
        }
    }];
}

#pragma mark -------- 删除地址
- (void)deleteUserAddressByID:(int)m_id
{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{@"addressId":[NSNumber numberWithInt:m_id]} subUrl:@"userAddress/deleteById" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        if ([resultDic[@"code"] integerValue]==200)
        {
            [self getAllUserAddress];
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
    }];
}


#pragma mark ------------------------Delegate-----------------------------
- (void)addNewUserAddress
{
    [self getAllUserAddress];
}

#pragma mark ------ 删除地址
- (void)address_delete:(int)index
{
    [self showAlertWithTitle:@"提示" message:@"确定要删除改地址吗" sureTitle:@"确定" cancelTitle:@"取消" sureAction:^(UIAlertAction *action)
    {
    
        UserAddressModel *model = [self.data objectAtIndex:index];
        int m_id = model.ad_id;
        [self deleteUserAddressByID:m_id];
        
    }
                cancelAction:^(UIAlertAction *action)
    {
        
    }];
}

#pragma mark ------ 编辑地址
- (void)address_edit:(int)index
{
    UserAddressModel *model = [self.data objectAtIndex:index];
    
    ZZAddressController *vc = [[ZZAddressController alloc]init];
    vc.delegate = self;
    vc.uModel = model;
    [self navigatePushViewController:vc animate:YES];
    
}


@end
