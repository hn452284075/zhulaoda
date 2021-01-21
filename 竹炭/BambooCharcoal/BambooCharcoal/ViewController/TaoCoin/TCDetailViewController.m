//
//  TCDetailViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/10/20.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "TCDetailViewController.h"
#import "TCDetailModel.h"

@interface TCDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView       *detailTable;
@property (nonatomic, strong) NSMutableArray    *dataSourceArray;

@end

@implementation TCDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageTitle = @"我的田币";
    
    //test data
    self.dataSourceArray = [[NSMutableArray alloc] init];
    for(int i=0;i<10;i++)
    {
        TCDetailModel *m = [[TCDetailModel alloc] init];
        m.timeStr       = @"2020-09-19 12:20:09";
        m.operatorStr   = @"充值";
        m.numberStr     = @"1088";
        [self.dataSourceArray addObject:m];
    }
    
    self.detailTable = [[UITableView alloc] init];
    [self.view addSubview:self.detailTable];
    [self.detailTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
    }];
    self.detailTable.delegate = self;
    self.detailTable.dataSource = self;
    self.detailTable.tableFooterView = [[UIView alloc] init];
    self.detailTable.separatorStyle = UITableViewCellSeparatorStyleNone;
}


#pragma mark ------------------------delegate------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 43.;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30, 43)];
    view.backgroundColor = UIColorFromRGB(0xebebeb);
    
    UILabel *lab1 = [[UILabel alloc] init];
    [self customLabel:lab1 tag:1];
    [view addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.centerY.equalTo(view.mas_centerY);
        make.height.equalTo(@20);
        make.width.mas_equalTo((kScreenWidth-30)/4*2);
    }];
    
    UILabel *lab2 = [[UILabel alloc] init];
    [self customLabel:lab2 tag:2];
    [view addSubview:lab2];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab1.mas_right);
        make.centerY.equalTo(view.mas_centerY);
        make.height.equalTo(@20);
        make.width.mas_equalTo((kScreenWidth-30)/4);
    }];

    UILabel *lab3 = [[UILabel alloc] init];
    [self customLabel:lab3 tag:3];
    [view addSubview:lab3];
    [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lab2.mas_right);
        make.centerY.equalTo(view.mas_centerY);
        make.height.equalTo(@20);
        make.width.mas_equalTo((kScreenWidth-30)/4);
    }];
    lab1.textColor       = UIColorFromRGB(0x222222);
    lab2.textColor       = UIColorFromRGB(0x222222);
    lab3.textColor       = UIColorFromRGB(0x222222);
    lab1.text = @"时间";
    lab2.text = @"操作";
    lab3.text = @"数量";
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 43.;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifystr = @"mcDetailCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifystr];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifystr];
        UILabel *lab1 = [[UILabel alloc] init];
        [self customLabel:lab1 tag:1];
        [cell addSubview:lab1];
        [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left);
            make.centerY.equalTo(cell.mas_centerY);
            make.height.equalTo(@20);
            make.width.mas_equalTo((kScreenWidth-30)/4*2);
        }];
        
        UILabel *lab2 = [[UILabel alloc] init];
        [self customLabel:lab2 tag:2];
        [cell addSubview:lab2];
        [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lab1.mas_right);
            make.centerY.equalTo(cell.mas_centerY);
            make.height.equalTo(@20);
            make.width.mas_equalTo((kScreenWidth-30)/4);
        }];

        UILabel *lab3 = [[UILabel alloc] init];
        [self customLabel:lab3 tag:3];
        [cell addSubview:lab3];
        [lab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lab2.mas_right);
            make.centerY.equalTo(cell.mas_centerY);
            make.height.equalTo(@20);
            make.width.mas_equalTo((kScreenWidth-30)/4);
        }];
        
        UIView *lineview = [[UIView alloc] init];
        lineview.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [cell addSubview:lineview];
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.mas_bottom).offset(-1);
            make.left.equalTo(cell.mas_left).offset(0);
            make.right.equalTo(cell.mas_right).offset(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    TCDetailModel *m = [self.dataSourceArray objectAtIndex:indexPath.row];
    UILabel *lab1 = [cell viewWithTag:1];
    UILabel *lab2 = [cell viewWithTag:2];
    UILabel *lab3 = [cell viewWithTag:3];
    lab1.text = m.timeStr;
    lab2.text = m.operatorStr;
    lab3.text = m.numberStr;
    
    lab2.textColor = UIColorFromRGB(0xFF4706);
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark ------------------------private------------------------------
- (void)customLabel:(UILabel *)lab tag:(int)tag
{
    lab.textColor       = UIColorFromRGB(0x666666);
    lab.textAlignment   = NSTextAlignmentCenter;
    lab.font            = CUSTOMFONT(12);
    lab.tag             = tag;
}


#pragma mark ------------------------view event------------------------------


#pragma mark ------------------------api------------------------------




@end
