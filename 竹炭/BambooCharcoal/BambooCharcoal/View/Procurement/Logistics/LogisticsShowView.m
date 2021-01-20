//
//  LogisticsShowView.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/9.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "LogisticsShowView.h"
#import "LogisticsCell.h"
#import "UIView+BlockGesture.h"
#import "UIView+Frame.h"
@interface LogisticsShowView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)NSArray *dataArray;
@property (strong, nonatomic)UITableView *table;
@end
@implementation LogisticsShowView
- (instancetype)initWithDatas:(NSArray*)array {
    self = [super init];
    if (self) {
        self.dataArray = array;
        [self setupUI];
    }
    
    return self;
}

-(void)colse{
   
    WEAK_SELF
    [UIView animateWithDuration:0.3 animations:^{
        
        weak_self.table.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 0);
        

    } completion:^(BOOL finished) {
     [self removeFromSuperview];
    }];
     
}
- (void)setupUI {
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _bgView.backgroundColor =  [UIColor colorWithWhite:0.f alpha:0.5];
    WEAK_SELF
    [_bgView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [weak_self colse];
    }];
    [self addSubview:_bgView];
    
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
    table.backgroundColor=[UIColor whiteColor];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_bgView addSubview:table];
    self.table = table;
     
    [UIView animateWithDuration:0.3 animations:^{
              
        weak_self.table.frame = CGRectMake(0,kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight);
              
              
    } completion:^(BOOL finished) {
          
          
    }];
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 41)];
    headerView.backgroundColor = KViewBgColor;
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 180, 13)];
    titleLabel.textColor = UIColorFromRGB(0x666666);
    titleLabel.textAlignment=1;
    titleLabel.text = @"申通快递77304642485888";
    titleLabel.font=CUSTOMFONT(13);
    [headerView addSubview:titleLabel];
    
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    copyBtn.frame = CGRectMake(titleLabel.right, 10, 50, 25);
    [copyBtn setImage:IMAGE(@"numCopy") forState:UIControlStateNormal];
    [copyBtn addTarget:self action:@selector(copyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:copyBtn];
 
    self.table.tableHeaderView=headerView;
}

-(void)copyBtnClick{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"";
    [[BaseLoadingView sharedManager]showSuccessInfoWithStatus:@"复制成功"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogisticsCell"];
    if (cell == nil) {
        
        cell = [[LogisticsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LogisticsCell"];
    }
    
    if (indexPath.row == 0) {
        cell.currented = YES;
    } else {
        cell.currented = NO;
    }
    
    if (indexPath.row == self.dataArray.count - 1) {
        cell.hasDownLine = NO;
    } else {
        cell.hasDownLine = YES;
    }
    cell.index=indexPath.row;
    LogisticModel *model = [self.dataArray objectAtIndex:indexPath.row];
    [cell reloadDataWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LogisticModel *model = [self.dataArray objectAtIndex:indexPath.row];
    return model.height;
}

 

 
 

@end
