//
//  BuyHallInfoViewController.m
//  PeachBlossom_iOS
//
//  Created by rover on 2020/9/8.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "BuyHallInfoViewController.h"
#import "BuyHallInfoModel.h"
#import "BuyHallInfoHeaderView.h"
#import "MYLabel.h"
#import "BuyHallOfferPriceModel.h"
#import "OfferPriceCellView.h"
#import "PurchasePriceView.h"
#import "IQKeyboardManager.h"
#import "MycommonTableView.h"
#import "HXPhotoManager.h"
#import "UIViewController+HXExtension.h"
#import "UploadPhotoManager.h"
@interface BuyHallInfoViewController ()<UITableViewDelegate,UITableViewDataSource,OfferPriceCellDelegate,PurchasePriceDelegate>
@property (nonatomic,strong)HXPhotoManager *manager;

@property (nonatomic, strong) MycommonTableView *tableview;

@property (nonatomic, strong) PurchasePriceView *purView;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) BuyHallInfoModel *infoModel;

@property (nonatomic,strong)NSMutableArray *dataUrlArr;

@end

@implementation BuyHallInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //写入这个方法后,这个页面将没有这种效果
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //最后还设置回来,不要影响其他页面的效果
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.pageTitle = @"求购信息";
    self.view.backgroundColor = UIColorFromRGB(0xf7f7f7);
    
    //初始化tableview
    [self _initTableView];
    //获取求购详情
    [self _requstDetailInfo];

}

#pragma mark ------------------------Init---------------------------------
- (UIView *)_tableHeaderView
{
    int h = [self calcModelHeight:self.infoModel];
    
    
    
    BuyHallInfoHeaderView *view = [[BuyHallInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, h+200) infoModel:self.infoModel];
    view.backgroundColor = UIColorFromRGB(0xededed);
   
    return view;
}

- (void)_initTableView
{
    if (self.tableview==nil) {
        
    
    self.tableview = [[MycommonTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableview];
    self.tableview.noDataLogicModule.needDealNodataCondition=NO;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.bottom.equalTo(self.view.mas_bottom).offset(-80);
        make.width.mas_equalTo(kScreenWidth);
    }];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = UIColorFromRGB(0xededed);
    
    
    WEAK_SELF
    [self.tableview headerRreshRequestBlock:^{
        weak_self.tableview.dataLogicModule.currentDataModelArr = @[].mutableCopy;
        weak_self.tableview.dataLogicModule.requestFromPage=1;

        [weak_self _requstDetailInfo];
    }];


    [self.tableview footerRreshRequestBlock:^{
        [weak_self _requstDetailInfo];

    }];
    }
}

- (void)_initPurcashView
{
    UIView *bv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bv.tag = 112;
    bv.backgroundColor =  [UIColor lightGrayColor];
    bv.alpha = 0.0;
    [self.view addSubview:bv];
    WEAK_SELF
    [bv addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [self.view endEditing:YES];
        UIView *_bv = [weak_self.view.window viewWithTag:112];
        _bv.alpha = 0.0;
        [weak_self pullViewOff];
    }];
    
    self.purView = [[[NSBundle mainBundle] loadNibNamed:@"PurchasePriceView" owner:self options:nil] lastObject];
    self.purView.delegate = self;
    [self.purView congfigView];
    [self.view addSubview:self.purView];
    [self.purView.submitBtn setTitle:@"报价" forState:UIControlStateNormal];
    [self.purView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-80);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(230);
    }];
    
    [self.purView.detailTextview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.purView.textfiledBackview.mas_bottom).offset(5);
        make.right.equalTo(self.purView.mas_right).offset(-13);
        make.left.equalTo(self.purView.mas_left).offset(13);
        make.height.mas_equalTo(86);
    }];
    
    [self.purView.submitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.purView.textfiledBackview.mas_top);
        make.right.equalTo(self.purView.publicLabel.mas_right);
        make.width.mas_equalTo(69);
        make.height.mas_equalTo(30);
    }];
    self.purView.publicLabel.hidden = YES;
    self.purView.checkBtn.hidden    = YES;
    self.purView.moreBtn.hidden     = YES;
    self.purView.detailTextview.hidden = YES;
}
 
#pragma mark ------------------------Private------------------------------
- (void)scrollToBottom{
      if (self.tableview.dataLogicModule.currentDataModelArr.count == 0) {
        return;
       }
      //获取最后一行
      NSIndexPath *lastIndex = [NSIndexPath     indexPathForRow:self.tableview.dataLogicModule.currentDataModelArr.count-1 inSection:0];
      [self.tableview scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

//把报价view拉起来
- (void)pullViewOn
{
    UIView *_bv = [self.view.window viewWithTag:112];
    _bv.alpha = 0.5;
    [self.purView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(230);
    }];
    [self.purView.submitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.purView.caremaBtn.mas_centerY).offset(-5);
        make.right.equalTo(self.purView.publicLabel.mas_right);
        make.width.mas_equalTo(69);
        make.height.mas_equalTo(30);
    }];
    self.purView.publicLabel.hidden = NO;
    self.purView.checkBtn.hidden    = NO;
    self.purView.moreBtn.hidden     = NO;
    self.purView.detailTextview.hidden = NO;
    [self.purView.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
}

//把报价view压下去
- (void)pullViewOff
{
    [self.purView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).offset(-80);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(230);
    }];
    [self.purView.submitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.purView.textfiledBackview.mas_top);
        make.right.equalTo(self.purView.publicLabel.mas_right);
        make.width.mas_equalTo(69);
        make.height.mas_equalTo(30);
    }];
    self.purView.publicLabel.hidden = YES;
    self.purView.checkBtn.hidden    = YES;
    self.purView.moreBtn.hidden     = YES;
    self.purView.detailTextview.hidden = YES;
    
    [self.purView.submitBtn setTitle:@"报价" forState:UIControlStateNormal];
}


- (MYLabel *)customLabel:(NSString *)string colorR:(int)cr colorG:(int)cg colorB:(int)cb fontSzie:(int)size rect:(CGRect)rect
{
    MYLabel *lab  = [[MYLabel alloc] initWithFrame:rect];
    lab.textColor = kGetColor(cr, cg, cb);
    lab.font      = CUSTOMFONT(size);
    lab.text      = string;
    lab.numberOfLines = 0;
    lab.textAlignment = NSTextAlignmentLeft;
    [lab setVerticalAlignment:VerticalAlignmentTop];
    return lab;
}

//根据文字计算label的高度
- (int)calcLabHeight:(NSString *)string fontSize:(int)size maxWidth:(int)w
{
    NSDictionary * dict = @{
        NSFontAttributeName : [UIFont systemFontOfSize:size]
    };
    return [string boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dict context:nil].size.height;
}


//计算整个表头Model将会占据的高度
- (int)calcModelHeight:(BuyHallInfoModel *)model
{
    int h1 = [self calcLabHeight:model.info_addr_go fontSize:14 maxWidth:kScreenWidth-65-15*4-5];
    int h2 = [self calcLabHeight:model.info_msg fontSize:14 maxWidth:kScreenWidth-65-15*4-5];
    int area_h = [self calcLabHeight:model.info_addr_get fontSize:14 maxWidth:kScreenWidth-65-15*4-5];
    int h3 = 0;
    int imgH = (kScreenWidth-30-5*2) / 4;
    
    int c = (int)model.info_imageArray.count;
    
    int v_1 = c/4;
    int v_2 = (c%4) > 0 ? imgH : 0;
    h3 = v_1*imgH + v_2;
    
    return area_h+h1+h2+(h3+10);
}



#pragma mark ------------------------Page Navigate------------------------

#pragma mark ------------------------View Event---------------------------

#pragma mark ------------------------Delegate-----------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyHallOfferPriceModel *pm = [self.tableview.dataLogicModule.currentDataModelArr objectAtIndex:indexPath.row];
    
    NSDictionary * dict = @{
        NSFontAttributeName : [UIFont systemFontOfSize:12]
    };
    CGSize size = [pm.op_msg boundingRectWithSize:CGSizeMake(kScreenWidth-15*2-38-7, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    NSArray *c_arr = pm.op_imageArray;
    
    int count = (int)c_arr.count%3==0?(int)c_arr.count/3:((int)c_arr.count/3)+1;
    int cvheight = size.height+(kScreenWidth-15*2-38-7)/3*count+130-count*2;
    
    
    return cvheight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableview.dataLogicModule.currentDataModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"infocell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
    }
    cell.backgroundColor = UIColorFromRGB(0xededed);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    OfferPriceCellView *tempcv = (OfferPriceCellView *)[cell viewWithTag:1];
    if(tempcv != nil)
    {
        tempcv.delegate = nil;
        [tempcv removeFromSuperview];
    }
    
    BuyHallOfferPriceModel *pm = [self.tableview.dataLogicModule.currentDataModelArr objectAtIndex:indexPath.row];
    
    OfferPriceCellView *cv = [[OfferPriceCellView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) offerModel:pm];
    cv.delegate = self;
    if(indexPath.row == self.tableview.dataLogicModule.currentDataModelArr.count-1)
    {
        UIView *lineview = [cv viewWithTag:100];
        lineview.hidden = YES;
    }
    
    cv.tag = indexPath.row;
    [cell.contentView addSubview:cv];
    
    [cv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.mas_top);
        make.bottom.equalTo(cell.mas_bottom);
        make.left.equalTo(cell.mas_left);
        make.right.equalTo(cell.mas_right);
    }];
    
    return cell;
}

////报价框的相关代理
#pragma mark --------- 提交按钮
- (void)submit_action:(BOOL)isopen price:(NSString *)price detailInfo:(NSString *)detail
{
    
    if([[UserModel sharedInstance].verifyStatus intValue] != 1)
    {
        [self showMessage:@"请先实名认证"];
        return;
    }
    
    
    if(self.purView.detailTextview.hidden == YES)
    {
        [self pullViewOn];
    }
    else
    {
        if(isEmpty(self.purView.priceTextfiled.text) ||
           isEmpty(self.purView.detailTextview.text))
        {
            [self showMessage:@"参数不能为空"];
        }else{
            
            [self showHub];
            WEAK_SELF
               if (_dataArr.count>0) {
               
               self.dataUrlArr=[[NSMutableArray alloc]init];
             
             
              dispatch_semaphore_t signal = dispatch_semaphore_create(1);
                   
               for (NSDictionary *dic in self.dataArr) {
               
                   if (!isEmpty(dic[@"dataUrl"])) {//dataUrl 是存放的之前上传的资源url，没有就需要上传data生成新的阿里云地址
                       [weak_self.dataUrlArr addObject:dic[@"dataUrl"]];
                        dispatch_semaphore_signal(signal);
                   }else{
                   //用日期给文件命名
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    formatter.dateFormat = @"yyyyMMddHHmmss";
                    NSString *fileName = [formatter stringFromDate:[NSDate date]];
                   NSString *objectKey;
                   int num = (arc4random() % 1000000);
                   NSString *randomNumber = [NSString stringWithFormat:@"%.6d",num];
                   if ([dic[@"type"]isEqualToString:@"image"]) {
                       objectKey = [NSString stringWithFormat:@"ios/%@/%@.png",fileName,randomNumber];
                   }else{
                       objectKey = [NSString stringWithFormat:@"ios/%@/%@.mp4",fileName,randomNumber];
                   }
                   NSData *data = (NSData *)dic[@"data"];
                   [[UploadPhotoManager sharedInstance]uploadObjectAsyncWith:data withObjectKey:objectKey withPhotoBlock:^(NSString *dataUrl) {

                       [weak_self.dataUrlArr addObject:dataUrl];
                         dispatch_semaphore_signal(signal);
                   }];
                }
                   dispatch_semaphore_wait(signal, DISPATCH_TIME_FOREVER);
               }
            }
            
            
            [self _requstSubmitPurchaseApi:isopen purchaseID:[self.hallId intValue] detailInfo:detail price:price];
        }
    }
}

#pragma mark --------- 点击价格输入框事件
- (void)textfiledEdit_action
{
    if(self.purView.detailTextview.hidden == YES)
        [self pullViewOn];
}

#pragma mark --------- 点击购物车图标事件
- (void)cart_action
{
    
}

#pragma mark --------- 点击照相机图标事件
- (void)camare_action
{
    WEAK_SELF
    [self hx_presentSelectPhotoControllerWithManager:self.manager didDone:^(NSArray<HXPhotoModel *> *allList, NSArray<HXPhotoModel *> *photoList, NSArray<HXPhotoModel *> *videoList, BOOL isOriginal, UIViewController *viewController, HXPhotoManager *manager) {
        
        [weak_self imageArr:allList];
        NSLog(@"照片数量:%ld",allList.count);
            
        weak_self.purView.camareNumberLab.text = [NSString stringWithFormat:@"%d",(int)allList.count];
    
        } cancel:^(UIViewController *viewController, HXPhotoManager *manager) {
            NSSLog(@"block - 取消了");
        }];
    
    
}

-(void)imageArr:(NSArray *)allList{
        WEAK_SELF
        self.dataArr = [[NSMutableArray alloc]init];
        NSLog(@"%@",allList);
    
       // 1.创建一个串行队列，保证for循环依次执行
       dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
       // 2.异步执行任务
       dispatch_async(serialQueue, ^{
       // 3.创建一个数目为1的信号量，用于“卡”for循环，等上次循环结束在执行下一次的for循环
       dispatch_semaphore_t sema = dispatch_semaphore_create(1);
           
              
          for (HXPhotoModel *model in allList) {
              
              //说明已经有图片数据了,不需要再传已有的url地址
              if (!isEmpty(model.networkPhotoUrl)) {
                  weak_self.manager.configuration.photoCanEdit = NO;
                  weak_self.manager.configuration.videoCanEdit = NO;
                  dispatch_semaphore_signal(sema);
                  
              }
              
              //说明已经有图片数据了,不需要再传已有的url地址
              if (!isEmpty(model.videoURL)){
                  //model.videoURL 编辑后就有值，判断是否是网络视频地址
                  if ([model.videoURL.absoluteString containsString:@"http"]) {
                      
                      weak_self.manager.configuration.videoCanEdit = NO;
                      weak_self.manager.configuration.photoCanEdit = NO;
                      dispatch_semaphore_signal(sema);
                      
               }
                   
              }
              
              
              
              
              //取视频资源
              if (model.subType==1) {//视频
                  NSLog(@"%@",model.videoURL);
                  NSLog(@"%@",model.asset);
                
                  if (model.videoURL) {//编辑后才有的路径
                  NSData* videoData = [NSData dataWithContentsOfURL:model.videoURL];
                      [weak_self.dataArr addObject:@{@"type":@"video",@"data":videoData}];
                  
                      dispatch_semaphore_signal(sema);
                      
                  }else{
                  
                      if (!isEmpty(model.asset)) {
                          
                      
                    PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
                      options.version = PHVideoRequestOptionsVersionOriginal;
                      options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
                      options.networkAccessAllowed = YES;
                      [[PHImageManager defaultManager] requestAVAssetForVideo:model.asset options:options resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
                          AVURLAsset *videoAsset = (AVURLAsset*)avasset;
                          NSLog(@"AVAsset URL: %@",videoAsset.URL);
                          NSError* error = nil;
                          NSData* videoData = [NSData dataWithContentsOfURL:videoAsset.URL options:NSDataReadingUncached error:&error];
                          [weak_self.dataArr addObject:@{@"type":@"video",@"data":videoData}];
                          dispatch_semaphore_signal(sema);
                          
                       }];
                      }
                  }
                  
              }else{//图片
              
                  NSLog(@"end");
                  
                  
                  if (model.imageURL) {//编辑后才有的路径
                      
                      NSLog(@"%@",model.imageURL);
                       UIImage *image=[UIImage compressionImage:model.previewPhoto];
                       NSData *imageData = UIImagePNGRepresentation(image);
                         NSLog(@"压缩后%ld",[UIImage lengthOfImage:image]);
                         [weak_self.dataArr addObject:@{@"type":@"image",@"data":imageData}];
                      
                         dispatch_semaphore_signal(sema);
                      
                      
                  }else{
                  
                   if (!isEmpty(model.asset)) {
                          
                  __block NSData *currentData;
                              
                      PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
                      options.synchronous = YES;
                      options.networkAccessAllowed = YES;
                        
                        if (model.photoFormat==4) {
                            options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
                        }else{
                            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;

                        }
                      
                      [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:PHImageManagerMaximumSize  contentMode:PHImageContentModeAspectFit  options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                       
                          currentData = UIImagePNGRepresentation(result);
                              NSLog(@"压缩后%ld",[UIImage lengthOfImage:result]);
                        [weak_self.dataArr addObject:@{@"type":@"image",@"data":currentData}];
                         NSLog(@"dataArr:%ld",weak_self.dataArr.count);
                       
                         dispatch_semaphore_signal(sema);
                  
                      }];
                  
                      }
                    }
                  }              dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
           }
       });
    
       NSSLog(@"%@",allList);
    
}

#pragma mark --------- 获得更多曝光机会
- (void)more_action
{
    
}

#pragma mark --------- cell上的聊一聊点击事件
- (void)offerPriceCellChatAction:(UIButton *)btn event:(nonnull id)event
{
    OfferPriceCellView *tc = (OfferPriceCellView *)event;
//    UITableViewCell *cell = (UITableViewCell *)tc.superview;cell
//    NSIndexPath *indexpath = [self.tableview indexPathForCell:cell];
    
    NSLog(@"点击的聊一聊行  = %ld",(long)tc.tag);
}


#pragma mark ------------------------Notification-------------------------

#pragma mark ------------------------Getter / Setter----------------------

- (HXPhotoManager *)manager {
    if (!_manager) {
       _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
       _manager.configuration.saveSystemAblum = YES;
       _manager.configuration.photoMaxNum = 6;
       _manager.configuration.maxNum=6;
       _manager.configuration.videoMaxNum=0;
    }
    return _manager;
}
#pragma mark ------------------------Api----------------------------------
//获取采购详情
- (void)_requstDetailInfo
{
    NSDictionary *param = @{kRequestPageNumKey :@(self.tableview.dataLogicModule.requestFromPage),
                            kRequestPageSizeKey:@(kRequestDefaultPageSize),
                            @"purchaseId":self.hallId
                            };
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:param subUrl:@"PurchaseApi/purchaseDetail" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200)
        {
            NSDictionary *_infoDic = resultDic[@"params"][@"purchaseBaseVo"];
            
            weak_self.infoModel = [[BuyHallInfoModel alloc] init];
            weak_self.infoModel.info_id         = _infoDic[@"id"];
            weak_self.infoModel.info_title      = _infoDic[@"title"];
            weak_self.infoModel.info_addr_get   = _infoDic[@"purchaseAreaName"];
            weak_self.infoModel.info_addr_go    = _infoDic[@"destinationAreaName"];
            weak_self.infoModel.info_msg        = _infoDic[@"requirements"];
            weak_self.infoModel.info_imageArray = _infoDic[@"pics"];
            weak_self.infoModel.info_publisher  = _infoDic[@"purchaseUsername"];
            weak_self.infoModel.info_publishTime= _infoDic[@"updateTime"];
            weak_self.infoModel.info_unit       = _infoDic[@"unit"];
            weak_self.infoModel.info_period     = [NSString stringWithFormat:@"  %@  ",_infoDic[@"frequency"]];
            weak_self.infoModel.info_priceCount = resultDic[@"params"][@"quotedPriceVoIPage"][@"total"];
            
            NSMutableArray *tmparr = [[NSMutableArray alloc] init];
            NSArray *vosArray = resultDic[@"params"][@"quotedPriceVoIPage"][@"records"];
            for(int i=0;i<vosArray.count;i++)
            {
                NSDictionary *_dic = [vosArray objectAtIndex:i];
                BuyHallOfferPriceModel *pmodel = [[BuyHallOfferPriceModel alloc] init];
                pmodel.op_accid         = _dic[@"quotedAccid"];
                pmodel.op_name          = _dic[@"quotedName"];
                pmodel.op_adress        = _dic[@"address"];
                pmodel.op_imageArray    = _dic[@"pics"];
                pmodel.op_price         = _dic[@"quotedPrice"];
                pmodel.op_msg           = _dic[@"quotedNote"];
                pmodel.op_time          = _dic[@"quotedTime"];
                pmodel.op_headImg       = _dic[@"quotedAvatar"];
                [tmparr addObject:pmodel];
            }
                                        
            [weak_self.tableview configureTableAfterRequestPagingData:tmparr];
        
            weak_self.tableview.tableHeaderView = [weak_self _tableHeaderView];
            //底部报价栏
            [weak_self _initPurcashView];

            self.purView.priceUnitLabel.text = [NSString stringWithFormat:@"/%@",_infoDic[@"unit"]];
        }
        else
        {
            [weak_self showMessage:resultDic[@"desc"]];
        }
    }];
}


-(void)_requstSubmitPurchaseApi:(BOOL)openFlag purchaseID:(int)pid detailInfo:(NSString *)info price:(NSString *)price{
    
    WEAK_SELF


    [AFNHttpRequestOPManager postBodyParameters:@{
        
        @"isOpen"        : [NSNumber numberWithInt:openFlag],
        @"picList"       : self.dataUrlArr==nil?@[]:self.dataUrlArr,
        @"purchaseId"    : [NSNumber numberWithInt:pid],
        @"quotedNote"    : info,
        @"quotedPrice"   : price
        
    } subUrl:@"PurchaseApi/quotedPrice" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
                          
            dispatch_async(dispatch_get_main_queue(), ^{
                UIView *_bv = [weak_self.view.window viewWithTag:112];
                _bv.alpha = 0.0;
                [weak_self pullViewOff];
                weak_self.tableview.dataLogicModule.currentDataModelArr = @[].mutableCopy;
                weak_self.tableview.dataLogicModule.requestFromPage=1;
                [weak_self _requstDetailInfo];
                
            });
            
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
    }];
}

@end
