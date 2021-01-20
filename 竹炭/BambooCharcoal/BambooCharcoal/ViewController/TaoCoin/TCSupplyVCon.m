//
//  TCSupplyVCon.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/10/22.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "TCSupplyVCon.h"
#import "TCSupplyModel.h"
#import "TCSupplyCell.h"
#import "TCTGDetailVCon.h"

@interface TCSupplyVCon ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView       *supplyTable;
@property (nonatomic, strong) NSMutableArray    *dataSourceArray;

@end

@implementation TCSupplyVCon

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageTitle = @"选择供应";
    
    //test data
    self.dataSourceArray = [[NSMutableArray alloc] init];
    for(int i=0;i<10;i++)
    {
        TCSupplyModel *mm = [[TCSupplyModel alloc] init];
        mm.supply_goodsID = i+1;
        mm.supply_unit = @"公斤";
        mm.supply_price = @"23.58";
        mm.supply_title = @"又大又红的正宗新疆大西瓜";
        mm.supply_imgurl = @"http://pic.enorth.com.cn/005/008/058/00500805855_7c27df5b.jpg";
        
        [self.dataSourceArray addObject:mm];
    }
    
    [self _initTable];
    
}


#pragma mark ------------------------init------------------------------
- (void)_initTable
{
    int bottomH = 0;
    if(IS_Iphonex_Series)
        bottomH = 20;
    
    self.supplyTable = [[UITableView alloc] init];
    self.supplyTable.backgroundColor = UIColorFromRGB(0xf7f7f7);
    [self.view addSubview:self.supplyTable];
    [self.supplyTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-bottomH);
    }];
    self.supplyTable.delegate = self;
    self.supplyTable.dataSource = self;
    self.supplyTable.tableFooterView = [[UIView alloc] init];
    self.supplyTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark ------------------------delegate------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TCSupplyModel *m = [self.dataSourceArray objectAtIndex:indexPath.row];
    NSLog(@"点击的商品编号 == %d",m.supply_goodsID);
    
    TCTGDetailVCon *vc = [[TCTGDetailVCon alloc] init];
    [self navigatePushViewController:vc animate:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifystr = @"TCSupplyCell";
    TCSupplyCell *cell=[tableView dequeueReusableCellWithIdentifier:identifystr];
    if(!cell){
        cell = [[TCSupplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifystr];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TCSupplyModel *m = [self.dataSourceArray objectAtIndex:indexPath.row];
    [cell configCellData:m];
    return cell;
}


#pragma mark ------------------------ipa------------------------------


@end
