//
//  PersonalDataVC.m
//  PeachBlossom_iOS
//
//  Created by 曾勇兵 on 2020/9/4.
//  Copyright © 2020 zengyongbing. All rights reserved.
//

#import "PersonalDataVC.h"
#import "PersonalDataView.h"
#import "HXPhotoView.h"
#import "UIView+Frame.h"
#import "JWAddressPickerView.h"
#import "IQKeyboardManager.h"
#import "PhotoView.h"
#import "UnitView.h"
#import "SetSpecsViewController.h"
#import "UserInfoModel.h"
#import "UploadPhotoManager.h"

@interface PersonalDataVC ()<HXPhotoViewDelegate,SetSpecsInfoDelegate>
@property (strong, nonatomic)PersonalDataView *headerView;
@property (nonatomic,strong)HXPhotoView *photoView;
@property (strong, nonatomic)HXPhotoManager *manager;
@property (nonatomic,strong)UnitView   *identityView;//选取身份弹窗
@property (strong, nonatomic)UIScrollView *scrollView;
@property (nonatomic,strong)NSMutableArray *imageDataArr;
@property (nonatomic,strong)NSString *categoryId;;//采购商品类id
@property (nonatomic, assign) int userID; //用户ID
@property (nonatomic, strong) UserInfoModel *userInfo;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *dataUrlArr;
@property (nonatomic,strong)NSMutableArray *annexesArr;


@end

@implementation PersonalDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageTitle=@"完善个人资料";
    [self initUI];
    self.view.backgroundColor=KViewBgColor;
    self.annexesArr = [[NSMutableArray alloc]init];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //写入这个方法后,这个页面将没有这种效果
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [self getUserInfo];
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
    
    UIView *bootomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kStatusBarAndNavigationBarHeight-61, kScreenWidth, 61)];
    bootomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bootomView];
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveBtn.frame = CGRectMake(15, 10.5, kScreenWidth-30, 40);
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font=CUSTOMFONT(14);
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setBackgroundColor:KCOLOR_Main];
    saveBtn.layer.cornerRadius=20;
    [bootomView addSubview:saveBtn];
}

#pragma mark ------------------------Api----------------------------------
#pragma mark ------ 获取用户身份列表
-(void)getCapacity{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"UserApi/getCapacity" block:^(NSDictionary *resultDic, NSError *error) {
        NSLog(@"resultDic:%@",resultDic);
        [weak_self dissmiss];
        if ([resultDic[@"code"] integerValue]==200) {
             NSArray *arr = resultDic[@"params"];
            weak_self.identityView = [[UnitView alloc] initWithFrame:CGRectMake(0, 0-kStatusBarAndNavigationBarHeight, kScreenWidth, kScreenHeight) title:nil tagArr:arr];
            [weak_self.identityView setDefaultSelected:weak_self.headerView.identityField.text];
            WEAK_SELF
            weak_self.identityView.seletecdStrBlock = ^(NSString *str) {
                weak_self.headerView.identityField.text = str;
                [weak_self.identityView removeFromSuperview];
            };

            [weak_self.view addSubview:weak_self.identityView];
         }else{
            [weak_self showMessage:resultDic[@"desc"]];
             
        }
    }];
}

#pragma mark ------ 获取用户信息
- (void)getUserInfo
{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:nil subUrl:@"UserApi/userDetailsInformation" block:^(NSDictionary *resultDic, NSError *error) {
        NSLog(@"resultDic:%@",resultDic);
        weak_self.headerView.textView.hidden=NO;
        [weak_self dissmiss];
        if ([resultDic[@"code"] integerValue]==200) {
            
            [weak_self getUserInfoFromDic:resultDic];
           
         }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
    }];
}

- (void)getUserInfoFromDic:(NSDictionary *)resultDic
{
    
    self.annexesArr = resultDic[@"params"][@"annexes"];
    //解析获取到的信息数据
    self.userInfo = [[UserInfoModel alloc] init];
    self.userInfo.userid   = [NSString stringWithFormat:@"%@",resultDic[@"params"][@"id"]];
    self.userInfo.accid   = [NSString stringWithFormat:@"%@",resultDic[@"params"][@"accid"]];
    self.userInfo.area     = resultDic[@"params"][@"area"];
    self.userInfo.areaId     = resultDic[@"params"][@"areaId"];
    self.userInfo.avatar   = resultDic[@"params"][@"userPortraitUrl"];
    self.userInfo.capacity = resultDic[@"params"][@"capacity"];
    self.userInfo.myself   = resultDic[@"params"][@"introduction"];
    self.userInfo.nickname = resultDic[@"params"][@"nickName"];
    self.userInfo.major    = resultDic[@"params"][@"major"];
    self.userInfo.annexes  = [[NSMutableArray alloc] init];
    NSArray *arr = resultDic[@"params"][@"annexes"];
    for(int i=0;i<arr.count;i++)
    {
        NSDictionary *dic = [arr objectAtIndex:i];
        annexes *an = [[annexes alloc] init];
        an.accid    = dic[@"accid"];
        an.picUrl   = dic[@"picUrl"];
        an.imageid  = dic[@"id"];
        an.addTime  = dic[@"addTime"];
        [self.userInfo.annexes addObject:an];
    }
    [UserModel sharedInstance].username = self.userInfo.nickname;
    self.headerView.nameFiled.text      = self.userInfo.nickname;
    self.headerView.identityField.text  = self.userInfo.capacity;
    self.headerView.typeField.text      = self.userInfo.major;
    self.headerView.addressField.text   = self.userInfo.area;
    self.headerView.textView.text       = self.userInfo.myself;
    [self.headerView.userImage sd_SetImgWithUrlStr:self.userInfo.avatar placeHolderImgName:@"my-header"];
 
    NSMutableArray *assets = @[].mutableCopy;
    for (int i=0; i<self.annexesArr.count; i++) {
        NSDictionary *dic = self.annexesArr[i];
       if ([dic[@"picUrl"] containsString:@"mp4"]) {
       HXCustomAssetModel *assetVideo = [HXCustomAssetModel assetWithLocalVideoURL:[NSURL URLWithString:dic[@"picUrl"]] selected:YES];
           [assets addObject:assetVideo];
       }else{
           HXCustomAssetModel *asset = [HXCustomAssetModel assetWithNetworkImageURL:[NSURL URLWithString:dic[@"picUrl"]] selected:YES];
           [assets addObject:asset];
       }
       
       
   }
   [self.manager addCustomAssetModel:assets];
   [self.photoView refreshView];
}



#pragma mark ------ 更新用户信息
- (void)updateUserInfo:(NSString *)name identify:(NSString *)iden type:(NSString *)type address:(NSString *)address info:(NSString *)info
{
    WEAK_SELF
    [self showHub];
    [AFNHttpRequestOPManager postWithParameters:@{
        @"id":self.userInfo.userid,
        @"areaId":address,
        @"capacity":iden,
        @"major":type,
        @"introduction":info,
        @"nickName":name,
        @"userPortraitUrl":self.userInfo.avatar,
        @"accid:":self.userInfo.accid
        
    } subUrl:@"UserApi/updateUserDetailsInformation" block:^(NSDictionary *resultDic, NSError *error) {
        NSLog(@"resultDic:%@",resultDic);
        [weak_self dissmiss];
        if ([resultDic[@"code"] integerValue]==200) {
            
            
            
            
            [[UserModel sharedInstance]saveUserInfo:@{
                @"token":[UserModel sharedInstance].token,
                @"accid":[UserModel sharedInstance].userId,
                @"username":name
            }.mutableCopy];
            
            if (weak_self.dataArr.count==0) {
                [weak_self showSuccessInfoWithStatus:@"保存成功"];
                [weak_self goBack];
            }else{
                [weak_self submitUserImageArray];
            }
         }else{
            [weak_self showMessage:resultDic[@"desc"]];
        }
    }];
    
}

#pragma mark ------ 提交图片上传阿里云
-(void)submitUserImageArray{
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
       
           
           NSLog(@"dataUrl:%@",self.dataUrlArr);
       
    }
    
    //拿到阿里云图片地址后
    [self submitData];
        
}

#pragma mark ------ 提交图片
-(void)submitData{

    
    WEAK_SELF
    for (int a=0; a<self.dataUrlArr.count; a++) {
        [self showWithStatus:@"上传中..."];
           NSDictionary *param = @{@"picUrl":_dataUrlArr[a]};
           [AFNHttpRequestOPManager postWithParameters:param subUrl:@"userPhoto/add" block:^(NSDictionary *resultDic, NSError *error) {
               [weak_self dissmiss];
               NSLog(@"resultDic:%@",resultDic);
               if ([resultDic[@"code"] integerValue]==200) {
                   if (a==weak_self.dataUrlArr.count-1) {
                       [weak_self showSuccessInfoWithStatus:@"保存成功"];
                        [weak_self goBack];
                   }
                   
               }else{
                   [weak_self showMessage:resultDic[@"desc"]];
               }
               
           }];
           
    }
 
}


#pragma mark ------ 删除图片
-(void)deleteImageId:(NSString *)str{
    
        WEAK_SELF
        [self showHub];
        NSDictionary *param = @{@"fileId":str};
        [AFNHttpRequestOPManager postWithParameters:param subUrl:@"userPhoto/deleteById" block:^(NSDictionary *resultDic, NSError *error) {
            [weak_self dissmiss];
            NSLog(@"resultDic:%@",resultDic);
            if ([resultDic[@"code"] integerValue]==200) {
                [weak_self showSuccessInfoWithStatus:@"删除成功"];
                
            }else{
                [weak_self showMessage:resultDic[@"desc"]];
            }
            
        }];
    

}

#pragma mark ------------------------View Event---------------------------
-(void)saveBtnClick
{
    NSString *name = self.headerView.nameFiled.text;
    NSString *identify = self.headerView.identityField.text;
    NSString *type = self.headerView.typeField.text;
    NSString *address = self.headerView.addressField.text;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ProData" ofType:@"plist"];
       NSDictionary *prodic = [[NSDictionary alloc] initWithContentsOfFile:path];
       //根据地址查找id
    NSString *idstr;
       if(prodic != nil)
       {
        
           idstr = [NSString stringWithFormat:@"%d",[[prodic valueForKey:address] intValue]];
           
           if([idstr isEqualToString:@"0"]){
               idstr = @"1271";
           }
    
           self.userInfo.areaId=idstr;
       }
    NSLog(@"%@",idstr);
    
    NSString *info = self.headerView.textView.text;
    if (name.length==0) {
        [self showMessage:@"请填写姓名"];
        return;
    }
    
    if(type.length == 0 || address.length == 0)
    {
        [self showMessage:@"主营和所在地为必填项"];
    }
    else
    {
        [self updateUserInfo:name identify:identify type:type address:self.userInfo.areaId info:info];
    }
}
//选取头像
-(void)userImageClick{
    WEAK_SELF
    [[PhotoView photoManager]seletecdIndexBlock:^(NSData *data,NSString *fileStr) {
        [weak_self uploadData:data AndobjectKey:fileStr];
        
    }];
}

-(void)uploadData:(NSData*)iconData AndobjectKey:(NSString*)objectKey{
    WEAK_SELF
    [[UploadPhotoManager sharedInstance]uploadObjectAsyncWith:iconData withObjectKey:objectKey withPhotoBlock:^(NSString *imgUrl) {
               NSLog(@"%@",imgUrl);
        weak_self.userInfo.avatar = imgUrl;
        
        [weak_self.headerView.userImage sd_SetImgWithUrlStr:imgUrl placeHolderImgName:@"my-header"];
    }];
}

//选取身份
-(void)userIdentityClick{
    
    [self getCapacity];
}



#pragma mark ------------------------Page Navigate---------------------------
-(void)jumpSetSpecsVC{
  SetSpecsViewController *vc = [[SetSpecsViewController alloc] init];
  vc.delegate=self;
  [self navigatePushViewController:vc animate:YES];
}

#pragma mark ------------------------Delegate-----------------------------
#pragma mark ------------ 类目选择完成
- (void)specsConfirmInfo:(NSString *)spstr idstring:(NSString *)idstr
{
    _headerView.typeField.text = spstr;
    _categoryId = idstr;
    NSLog(@"类目名称 = %@  类目ID = %@",spstr,idstr);
}

#pragma mark ------------ 视频/图片选择完成
- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    
    
    if (allList.count>0) {
        self.headerView.photoLabel.hidden=YES;
    }else{
        self.headerView.photoLabel.hidden=NO;
    }
    
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
                  NSData *imageData=[UIImage imageData:model.previewPhoto];
                   
                      [weak_self.dataArr addObject:@{@"type":@"image",@"data":imageData}];
                   
                      dispatch_semaphore_signal(sema);
                   
                   
               }else{
               
                if (!isEmpty(model.asset)) {
                       
               
              
                          
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
                      
                    [weak_self.dataArr addObject:@{@"type":@"image",@"data":imageData}];
                     NSLog(@"dataArr:%ld",weak_self.dataArr.count);
                   
                     dispatch_semaphore_signal(sema);
              
                  }];
              
                  }
                }
              }
           dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
    });
 
    NSSLog(@"%@",allList);
}

- (void)photoView:(HXPhotoView *)photoView currentDeleteModel:(HXPhotoModel *)model currentIndex:(NSInteger)index{
    
    if (!isEmpty(model.networkPhotoUrl)) {
        
        for (NSDictionary *dic in self.annexesArr) {
            if ([dic[@"picUrl"] isEqualToString:model.networkPhotoUrl.absoluteString]) {
                NSLog(@"删除:%@",dic[@"id"]);
                [self deleteImageId:dic[@"id"]];
            }
        }
        
    }
    
    if ([model.videoURL.absoluteString containsString:@"http"]) {
        for (NSDictionary *dic in self.annexesArr) {
            if ([dic[@"picUrl"] isEqualToString:model.videoURL.absoluteString]) {
                NSLog(@"删除:%@",dic[@"id"]);
                [self deleteImageId:dic[@"id"]];
            }
        }

    }
    
    
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"frame:%@",NSStringFromCGRect(frame));
    _headerView.photoBgViewHeight.constant =frame.size.height;
     self.scrollView.contentSize = CGSizeMake(self.scrollView.width, kScreenHeight+frame.size.height);
    _headerView.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight+frame.size.height);
}


#pragma mark ------------------------Getter / Setter----------------------
- (PersonalDataView *)headerView{
    if (!_headerView) {
        _headerView = BoundNibView(@"PersonalDataView", PersonalDataView);
        _headerView.typeField.userInteractionEnabled = YES;
        _headerView.regioBtn.userInteractionEnabled = YES;
        _photoView = [[HXPhotoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 85, 0) manager:self.manager];
         _photoView.delegate = self;
         _photoView.backgroundColor = [UIColor clearColor];
         _photoView.spacing=8;
         _photoView.lineCount=4;
         _photoView.outerCamera = YES;
         _photoView.showAddCell = YES;
         [_photoView refreshView];
         [_headerView.photoBgView addSubview:_photoView];
        _headerView.textView.hidden=YES;
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"展示你的实力，增加客户信任的文字描述：如从业年限、种植面积、为哪些大客户供货、供应特色等。（最多500字）";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        [_headerView.textView addSubview:placeHolderLabel];
        placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
        [_headerView.textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
        
 
        WEAK_SELF
        [_headerView.userImageBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self userImageClick];
        }];
        
        [_headerView.identityBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            [weak_self userIdentityClick];
        }];
        
        [_headerView.regioBtn addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
            JWAddressPickerView *tmppick = [JWAddressPickerView showWithAddressBlock:^(NSString *province, NSString *city, NSString *area) {
                                                
                weak_self.headerView.addressField.text =[NSString stringWithFormat:@"%@ - %@ - %@",province,city,area];
            }];
            
            if (!isEmpty(self.userInfo.area)) {
                if([self.userInfo.area rangeOfString:@"-"].location != NSNotFound)
                {
                    NSArray *tmpArray = [self.userInfo.area componentsSeparatedByString:@" - "];
                    
                    [tmppick setDefaultPro:tmpArray[0] city:tmpArray[1] town:tmpArray[2]];
                }
            }
            
            
        }];
        
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
