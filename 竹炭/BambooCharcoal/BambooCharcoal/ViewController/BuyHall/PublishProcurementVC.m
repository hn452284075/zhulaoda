//
//  PublishProcurementVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/8.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "PublishProcurementVC.h"
#import "PublishProcurementView.h"
#import "HXPhotoView.h"
#import "UIView+Frame.h"
#import "UnitView.h"
#import "SetSpecsViewController.h"
#import "SelectedProvinceView.h"
#import "JWAddressPickerView.h"
#import "IQKeyboardManager.h"
#import "UploadPhotoManager.h"
@interface PublishProcurementVC ()<HXPhotoViewDelegate,SetSpecsInfoDelegate,SelectedProviceDelegate,SelectedProviceDelegate>
@property (strong,nonatomic) PublishProcurementView *headerView;
@property (nonatomic,strong)HXPhotoView *photoView;
@property (strong,nonatomic) HXPhotoManager *manager;
@property (strong,nonatomic) UIScrollView *scrollView;
@property (nonatomic,strong)UnitView   *unitView;  //计费单位弹窗
@property (nonatomic,strong)SelectedProvinceView  *pView;//选择省份地区的view
@property (nonatomic,strong)NSArray  *tagArray;  //计费单位--测试数组
@property (nonatomic,strong)NSString *categoryId;;//采购商品类id
@property (nonatomic, strong) NSDictionary      *allAddressDic;
@property (nonatomic, strong) NSArray           *selectedAreaArray;
@property (nonatomic, assign) int               deliverID;
@property (nonatomic, strong) NSString           *goodsID; //商品的ID
@property (nonatomic, assign) int               frequencyID; //采购频次ID
@property (nonatomic, strong) NSArray           *frequencyArray;
@property (nonatomic,strong)NSMutableArray *imageDataArr;
@property (nonatomic,strong)NSMutableArray *dataUrlArr;

@end

@implementation PublishProcurementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageTitle=@"发布采购";
    self.selectedAreaArray = [[NSMutableArray alloc] init];
    [kNotification addObserver:self selector:@selector(type:) name:@"goodsType" object:nil];
    [self initUI];
    
    [self _requstFrequency];
}

-(void)dealloc{
    [kNotification removeObserver:self];
}

- (void)type:(NSNotification *)info {
    NSDictionary *dic = info.object;
    _headerView.typeLabel.text = [NSString stringWithFormat:@"%@/%@",dic[@"categoryName"],dic[@"name"]];
    _headerView.typeLabel.textColor = UIColorFromRGB(0x111111);
    _categoryId = [NSString stringWithFormat:@"%@",dic[@"categoryId"]];
    _goodsID  = [NSString stringWithFormat:@"%@",dic[@"id"]];
    
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //写入这个方法后,这个页面将没有这种效果
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //最后还设置回来,不要影响其他页面的效果
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}


#pragma mark ------------------------Init---------------------------------
-(void)initUI{
    
   
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.backgroundColor=KViewBgColor;
    [self.view addSubview:_scrollView];
    [_scrollView addSubview:self.headerView];
    
        
}

#pragma mark ------------------------View Event---------------------------
-(void)selectIndex:(NSInteger)index{
    
    WEAK_SELF
    if (index==0) {
        SetSpecsViewController *vc = [[SetSpecsViewController alloc] init];
          vc.delegate=self;
        [self navigatePushViewController:vc animate:YES];
        
    }else if (index==1){
        [self.view endEditing:YES];
        if (isEmpty(self.goodsID)) {
            [self showMessage:@"请先选择产品分类"];
        }else{
        [self _requestDataWithCID:self.goodsID];
        }
    }else if (index==2){
        [self.view endEditing:YES];
        if(self.pView)
        {
            [self.pView removeFromSuperview];
        }
      
        self.pView = [[SelectedProvinceView alloc] initWithFrame:CGRectMake(0, -55, kScreenWidth, kScreenHeight) usedArray:nil isEidt:YES EditArray:(NSArray *)self.selectedAreaArray];;
        self.pView.delegate = self;
        [self.view addSubview:self.pView];
        
    }else{
        
        [self.view endEditing:YES];
        
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
        for(int i=0;i<self.frequencyArray.count;i++)
        {
            NSDictionary *dic = [self.frequencyArray objectAtIndex:i];
            [tempArr addObject:dic[@"name"]];
        }
        self.tagArray = tempArr;
        
          self.unitView = [[UnitView alloc] initWithFrame:CGRectMake(0, 0-kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight) title:@"请选择采购频次" tagArr:self.tagArray];
          self.unitView.seletecdStrBlock = ^(NSString *str) {
              
              for(int i=0;i<weak_self.frequencyArray.count;i++)
              {
                  NSDictionary *dic = [weak_self.frequencyArray objectAtIndex:i];
                  if([dic[@"name"] isEqualToString:str])
                  {
                      weak_self.frequencyID = [dic[@"code"] intValue];
                      break;;
                  }
              }
              
              weak_self.headerView.countLabel.text = str;
              weak_self.headerView.countLabel.textColor=UIColorFromRGB(0x111111);
              [weak_self.unitView removeFromSuperview];
          };

          [self.view addSubview:self.unitView];
    }
}


#pragma mark ------------------------Api----------------------------------
#pragma mark ------ 提交图片上传阿里云
-(void)submitUserImageArray{
    WEAK_SELF
    [self showWithStatus:@"发布中..."];
    self.dataUrlArr=[[NSMutableArray alloc]init];
       if (_imageDataArr.count>0) {
        dispatch_semaphore_t signal = dispatch_semaphore_create(1);
       for (NSDictionary *dic in self.imageDataArr) {
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
       
           
           NSLog(@"dataUrl:%@",self.dataUrlArr);

    }
    
    
    //拿到阿里云图片地址后
    NSString *numStr  = weak_self.headerView.numField.text;
    NSString *freqStr = weak_self.headerView.countLabel.text;
    NSString *areaStr = [weak_self getAreaIDStr];
    if(self.selectedAreaArray.count == 34)
        areaStr = @"";
    NSArray  *nameArr = [weak_self.headerView.typeLabel.text componentsSeparatedByString:@"/"];
    NSArray  *IdArr   = [weak_self.categoryId componentsSeparatedByString:@"/"];
    NSString *requStr = weak_self.headerView.requireTextView.text;
    NSString *unitStr = weak_self.headerView.unitLabel.text;
    if(isEmpty(numStr) || isEmpty(freqStr) || isEmpty(areaStr)||
       isEmpty(unitStr) || isEmpty(nameArr) || isEmpty(requStr))
    {
        [self showMessage:@"所有参数不能为空"];
        return;
    }
    
    NSDictionary *dic = @{

        @"categoryId"   :  [NSNumber numberWithInt:[[IdArr objectAtIndex:3] intValue]],
        @"categoryName" :  [nameArr objectAtIndex:3],
        @"productId"    :  [NSNumber numberWithInt:[[IdArr objectAtIndex:4] intValue]],
        @"productName"  :  [nameArr objectAtIndex:4],
        @"deliveryAreaId": [NSNumber numberWithInt:weak_self.deliverID],
        @"frequency"    :  [NSNumber numberWithInt:weak_self.frequencyID],
        @"purchaseArea" :  areaStr,
        @"quantity"     :  numStr,
        @"requirements" :  requStr,
        @"unit"         :  unitStr,
        @"attachments"  :  self.dataUrlArr
    };
    
    [self _requstPublishPurchase:dic];
        
}

#pragma mark ------ 提交所有参数
-(void)_requstPublishPurchase:(NSDictionary *)dic{
    WEAK_SELF
    
    [AFNHttpRequestOPManager postBodyParameters:dic subUrl:@"PurchaseApi/publishPurchase" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            
            [weak_self.delegate publishProcurementSuccess];
            
            [weak_self showSuccessInfoWithStatus:@"发布成功"];
            [weak_self goBack];
                        
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
        
    }];
}

//查询采购频次
- (void)_requstFrequency
{
    WEAK_SELF
//    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"PurchaseApi/purchaseFrequency" block:^(NSDictionary *resultDic, NSError *error) {
//        [weak_self dissmiss];
        weak_self.headerView.requireTextView.hidden=NO;
        NSLog(@"resultDic:%@",resultDic);
        if ([resultDic[@"code"] integerValue]==200) {
            weak_self.frequencyArray = resultDic[@"params"];
        
        }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
        
    }];
}

//查询采购单位
-(void)_requestDataWithCID:(NSString*)cid{

    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{@"categoryId":self.categoryId} subUrl:@"ShopApi/chooseCategoryUnit" block:^(NSDictionary *resultDic, NSError *error) {
        [weak_self dissmiss];
        NSLog(@"resultDic:%@",resultDic);
        weak_self.headerView.requireTextView.hidden=NO;
        if ([resultDic[@"code"] integerValue]==200) {
                        
            weak_self.tagArray = resultDic[@"params"];
                        
            weak_self.unitView = [[UnitView alloc] initWithFrame:CGRectMake(0, 0-kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight) title:@"请选择采购单位 " tagArr:weak_self.tagArray];
             
            weak_self.unitView.seletecdStrBlock = ^(NSString *str) {
                 
                 weak_self.headerView.unitLabel.text = str;
                 weak_self.headerView.unitLabel.hidden=NO;
                 [weak_self.unitView removeFromSuperview];
             };
            [weak_self.view addSubview:weak_self.unitView];

        }else{
            [weak_self showMessage:resultDic[@"msg"]];
        }
    }];
}


#pragma mark ------------------------Private------------------------------
- (NSString *)getProviceString:(NSArray *)parray
{
    if(parray.count > 3)
    {
        NSString *str = [NSString stringWithFormat:@"%@、%@、%@等%d个省市",parray[0],parray[1],parray[2],(int)parray.count];
        return str;
    }
    else
    {
        NSString *str;
        if(parray.count == 1)
            str = [NSString stringWithFormat:@"%@",parray[0]];
        else if(parray.count == 2)
            str = [NSString stringWithFormat:@"%@、%@",parray[0],parray[1]];
        else if(parray.count == 3)
            str = [NSString stringWithFormat:@"%@、%@、%@",parray[0],parray[1],parray[2]];
        return str;
    }
    return @"";
}

- (NSString *)getAreaIDStr
{
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    for(int i=0;i<self.selectedAreaArray.count;i++)
    {
        NSString *str = [self.selectedAreaArray objectAtIndex:i];
        int pid = [self getIDAddressFormFile:str cityname:nil disname:nil];
        NSString *pidStr = [NSString stringWithFormat:@"%d",pid];
        [resultStr appendString:pidStr];
        if(i != self.selectedAreaArray.count-1)
            [resultStr appendString:@","];
    }
    return resultStr;
}

- (int)getIDAddressFormFile:(NSString *)pname cityname:(NSString *)cname disname:(NSString *)dname
{
    if(self.allAddressDic == nil || self.allAddressDic.allKeys.count == 0)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"thy_area" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        self.allAddressDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    }
        
    NSArray *array = self.allAddressDic[@"params"];
    for (int i=0;i<array.count;i++) {
        NSDictionary *dic = array[i];
        NSArray *proArray = dic[@"childList"];
        NSString *p_name = dic[@"name"];
        if(cname == nil)
        {
            if([p_name isEqualToString:pname])  //只有省的情况，直接返回省ID
            {
                return [dic[@"id"] intValue];
            }
        }
        
        for(int j=0;j<proArray.count;j++)
        {
            NSDictionary *prodic = proArray[j];
            NSArray *disArray = prodic[@"childList"];
            NSString *c_name = prodic[@"name"];
            if(dname == nil)
            {
                if([c_name isEqualToString:cname])  //市的ID
                {
                    return [prodic[@"pid"] intValue];
                }
            }
            
            for(int k=0;k<disArray.count;k++)
            {
                NSDictionary *disdic = disArray[k];
                NSString *t_name = disdic[@"name"];
               
                if([t_name isEqualToString:dname])  //区ID
                {
                    return [prodic[@"pid"] intValue];
                }
            }
        }
    }
    return -1;
}


#pragma mark ------------------------Delegate-----------------------------
#pragma mark -------------------- 选中省份代理  parray即选中省份名称数组
- (void)confirmProvice:(NSArray *)parray{
    self.selectedAreaArray = parray;
    self.headerView.regionLabel.text=[self getProviceString:parray];
    self.headerView.regionLabel.textColor=UIColorFromRGB(0x111111);
}
#pragma mark ------------ 类目选择完成
- (void)specsConfirmInfo:(NSString *)spstr idstring:(NSString *)idstr
{
    _headerView.typeLabel.text = spstr;
    _headerView.typeLabel.textColor = UIColorFromRGB(0x111111);
    _categoryId = idstr;
    NSLog(@"类目名称 = %@  类目ID = %@",spstr,idstr);
    NSArray *arr = [idstr componentsSeparatedByString:@"/"];
    if(arr.count == 5)
        self.goodsID = [NSString stringWithFormat:@"%@",[arr objectAtIndex:4]];
}

 
#pragma mark ------------ 选取图片和视频
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    
    self.imageDataArr = [[NSMutableArray alloc]init];
    NSLog(@"%@",allList);
    
    // 1.创建一个串行队列，保证for循环依次执行
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    // 2.异步执行任务
    dispatch_async(serialQueue, ^{
    // 3.创建一个数目为1的信号量，用于“卡”for循环，等上次循环结束在执行下一次的for循环
    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
        
    WEAK_SELF
      for (HXPhotoModel *model in allList) {
          
         
                 printf("信号量等待中\n");
          //地址不为空,处理逻辑是有图片url就直接存，当增加了图片就去取资源--编辑商品图片逻辑
          if (!isEmpty(model.networkPhotoUrl)) {
              [weak_self.imageDataArr addObject:@{@"dataUrl":model.networkPhotoUrl.absoluteString}];
              
              dispatch_semaphore_signal(sema);
              
          }
          
          //地址不为空,处理逻辑是有视频url就直接存，当增加了视频就去取资源--编辑商品视频逻辑
          if (!isEmpty(model.videoURL)){
              //model.videoURL 编辑后就有值，判断是否是网络视频地址
              if ([model.videoURL.absoluteString containsString:@"http"]) {
                  [weak_self.imageDataArr addObject:@{@"dataUrl":model.videoURL.absoluteString}];
                  
                  dispatch_semaphore_signal(sema);
                  
              }
               
          }
          
          
          
          
          //取视频资源
          if (model.subType==1) {//视频
              NSLog(@"%@",model.videoURL);
              NSLog(@"%@",model.asset);
            
              if (model.videoURL) {//编辑后才有的路径
              NSData* videoData = [NSData dataWithContentsOfURL:model.videoURL];
                  [weak_self.imageDataArr addObject:@{@"type":@"video",@"data":videoData}];
              
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
                  [weak_self.imageDataArr addObject:@{@"type":@"video",@"data":videoData}];
                  dispatch_semaphore_signal(sema);
                  
               }];
              }
             
            }
          }else{//图片
          
              NSLog(@"end");
              
              
              if (model.imageURL) {//编辑后才有的路径
                  
                  NSLog(@"%@",model.imageURL);
                  
                  NSData *imageData=[UIImage imageData:model.previewPhoto];
                     [weak_self.imageDataArr addObject:@{@"type":@"image",@"data":imageData}];
                  
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
                   
                      NSData *imageData=[UIImage imageData:result];
                      
                      [weak_self.imageDataArr addObject:@{@"type":@"image",@"data":currentData}];
                       NSLog(@"dataArr:%ld",weak_self.imageDataArr.count);
                   
                     dispatch_semaphore_signal(sema);
              
                  }];
              
                  }
                }
              }
           dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
    });

}



- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"frame:%@",NSStringFromCGRect(frame));
    _headerView.photoBgViewHeight.constant =243-80+frame.size.height;
     self.scrollView.contentSize = CGSizeMake(self.scrollView.width, kScreenHeight+frame.size.height);
}


#pragma mark ------------------------Getter / Setter----------------------
- (PublishProcurementView *)headerView{
    if (!_headerView) {
           _headerView = BoundNibView(@"PublishProcurementView", PublishProcurementView);
            _headerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            _photoView = [HXPhotoView photoManager:self.manager scrollDirection:UICollectionViewScrollDirectionVertical];
            _photoView.frame = CGRectMake(12, 141, kScreenWidth - 14*2-12*2, 0);
             _photoView.delegate = self;
             _photoView.backgroundColor = [UIColor whiteColor];
             _photoView.spacing=11;
             _photoView.lineCount=4;
             _photoView.outerCamera = YES;
             _photoView.showAddCell = YES;
             [_photoView refreshView];
             [_headerView.photoBgView addSubview:_photoView];
            WEAK_SELF
            _headerView.seletecdIndexBlock = ^(NSInteger index) {
                [weak_self selectIndex:index];
            };
        [_headerView.regionBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [self.view endEditing:YES];
            JWAddressPickerView *tmppick = [JWAddressPickerView showWithAddressBlock:^(NSString *province, NSString *city, NSString *area) {
                weak_self.headerView.regionField.text =[NSString stringWithFormat:@"%@-%@-%@",province,city,area];
                weak_self.deliverID = [weak_self getIDAddressFormFile:nil cityname:nil disname:area];
            }];
            if([weak_self.headerView.regionField.text rangeOfString:@"-"].location != NSNotFound)
            {
                NSArray *tmpArray = [weak_self.headerView.regionField.text componentsSeparatedByString:@"-"];
                [tmppick setDefaultPro:tmpArray[0] city:tmpArray[1] town:tmpArray[2]];
            }
        }];
        //点击发布采购
        [_headerView.publishBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self submitUserImageArray];
          
        }];
        
        _headerView.requireTextView.hidden=YES;
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"请填写规格、包装和运输等要求";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        [_headerView.requireTextView addSubview:placeHolderLabel];
        placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
        [_headerView.requireTextView setValue:placeHolderLabel forKey:@"_placeholderLabel"];

        
        
        
    }
       return _headerView;
}



- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
       _manager.configuration.saveSystemAblum = YES;
       _manager.configuration.photoMaxNum = 14;
       _manager.configuration.videoMaxNum = 1;
       _manager.configuration.maxNum = 15;
       _manager.configuration.videoMaximumDuration=30;
       _manager.configuration.type = HXConfigurationTypeWXChat;
 
    }
    return _manager;
}
@end
