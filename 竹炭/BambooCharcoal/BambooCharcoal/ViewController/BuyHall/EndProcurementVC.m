//
//  EndProcurementVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/8.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "EndProcurementVC.h"
#import "UIView+Frame.h"
#import "MycommonTableView.h"
#import "MyShoppingCell.h"
#import "BuyHallHeaderView.h"
@interface EndProcurementVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UIImageView *topBgView;
@property (nonatomic,strong)MycommonTableView *listTableView;

@end

@implementation EndProcurementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    [self _initUI];

}

-(UIStatusBarStyle)preferredStatusBarStyle {

    return UIStatusBarStyleLightContent;
}

 

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xFFB300);
}

-(void)_requestOrderData{
    
}
#pragma mark ------------------------Init---------------------------------
-(void)_initUI{
     [self removeLine];
     [self setLeftWhileArrow];
     UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
       titleLable.font = [UIFont fontWithName:@"PingFang SC Bold" size:16.0f];
       titleLable.textAlignment = NSTextAlignmentCenter;
       titleLable.textColor = [UIColor whiteColor];
       titleLable.text = @"已结束的采购";
       self.navigationItem.titleView = titleLable;
       self.view.backgroundColor=KViewBgColor;
     _topBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1, kScreenWidth, 101)];
     [_topBgView setImage:IMAGE(@"qiugou-hbj")];
    
     [self.view addSubview:_topBgView];
     [self.view addSubview:self.listTableView];
}
#pragma mark ------------------------Delegate-----------------------------
 
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    MyShoppingCell *cell = [self.listTableView dequeueReusableCellWithIdentifier:@"MyShoppingCell" forIndexPath:indexPath];
       
    return cell;
 
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    MyShoppingCell *shopCell=(MyShoppingCell *)cell;
    shopCell.selectionStyle = UITableViewCellSelectionStyleNone;
     
    
    
  
   //判断当前只有一个cell
    if ([tableView numberOfRowsInSection:indexPath.section] == 1 && indexPath.row == 0) {
       
            shopCell.bgView.layer.masksToBounds = YES;
            shopCell.bgView.layer.cornerRadius = 8;
        
      
    }else{
        //刷新cell的时候把第一个圆角恢复
       
            shopCell.bgView.layer.masksToBounds = YES;
            shopCell.bgView.layer.cornerRadius = 0;
        
        
        if ([shopCell.bgView respondsToSelector:@selector(tintColor)]) {
            if (tableView == self.listTableView) {
                // 圆角弧度半径
                CGFloat cornerRadius = 8.f;
                // 设置cell的背景色为透明，如果不设置这个的话，则原来的背景色不会被覆盖
                CGRect bounds;
                
                shopCell.bgView.backgroundColor = UIColor.clearColor;
                bounds = CGRectInset(CGRectMake(14, 0, kScreenWidth-28, 171), 0, 0);
                
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
              
                    // view大小与cell一致
                    UIView *roundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 165)];
                   // 添加自定义圆角后的图层到roundView中
                   [roundView.layer insertSublayer:layer atIndex:0];
                   roundView.backgroundColor = UIColor.clearColor;
                   //cell的背景view
                   //cell.selectedBackgroundView = roundView;
                   shopCell.backgroundView = roundView;
                    
//                   //以上方法存在缺陷当点击cell时还是出现cell方形效果，因此还需要添加以下方法
//                   UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:bounds];
//                   backgroundLayer.fillColor = tableView.separatorColor.CGColor;
//                   [selectedBackgroundView.layer insertSublayer:backgroundLayer atIndex:0];
//                   selectedBackgroundView.backgroundColor = UIColor.clearColor;
//                   buyCell.selectedBackgroundView = selectedBackgroundView;
                
               
            }
        }
    }

}
#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------
- (MycommonTableView *)listTableView{
    
    if (!_listTableView) {
        _listTableView  = [[MycommonTableView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, kScreenHeight-kStatusBarAndNavigationBarHeight-10) style:UITableViewStylePlain];
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.showsVerticalScrollIndicator = NO;
        _listTableView.backgroundColor = [UIColor clearColor];
        _listTableView.delegate=self;
        _listTableView.dataSource=self;
        _listTableView.rowHeight=171;
        [_listTableView registerNib:[UINib nibWithNibName:@"MyShoppingCell" bundle:nil] forCellReuseIdentifier:@"MyShoppingCell"];
         [_listTableView configureTableAfterRequestPagingData:@[]];
        WEAK_SELF
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
