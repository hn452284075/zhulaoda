//
//  VisitorRecordViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/8.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "VisitorRecordViewController.h"
#import "visitorRecordCell.h"

@interface VisitorRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation VisitorRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.pageTitle = @"访客记录";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);    
    
    [self _initTableView];
}


- (void)_initTableView
{
    self.tableview = [[UITableView alloc] init];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(kScreenWidth);
    }];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = [UIColor clearColor];
}

#pragma mark ------------------------Api----------------------------------
#pragma mark ------------------------Page Navigate------------------------

#pragma mark ------------------------View Event---------------------------
- (void)btnClicked:(UIButton *)btn
{
    switch (btn.tag) {
        case 4:
        {
//            CustomManageViewController *vc = [[CustomManageViewController alloc] init];
//            [self navigatePushViewController:vc animate:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark ------------------------Delegate-----------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"visitorrecordcell";
    visitorRecordCell *cell = (visitorRecordCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"visitorRecordCell" owner:nil options:nil] firstObject];
        cell.headerImg.layer.cornerRadius = 20;
        cell.bgview.layer.cornerRadius = 5.;
        cell.bgview.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.headerImg.image = IMAGE(@"supply_goodsimg");
    cell.nameLabel.text = @"冰糖心苹果";
    cell.adressLabel.text = @"新疆阿克苏";
    cell.infoLabel_1.text = @"10小时前";
    cell.infoLabel_2.text = @"看了我的店铺";
    cell.infoLabel_3.text = @"你的大西瓜";
    
    return cell;
}

#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------

@end
