//
//  AddAddressVC.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "SheetChoseCity.h"
#import "DSRequest.h"

@protocol AddAddressVCDisMissDeelgate <NSObject>

@optional
- (void)addAddressVCDisMissedandReloadData;   //当在修改地址处操作成功后  点击返回按钮是实现此协议方法

@end

@interface AddAddressVC : CommonViewController<UITextFieldDelegate,SheetChoseCityDelegate,DSRequestDelegate,UIActionSheetDelegate>

@property (nonatomic, assign) id<AddAddressVCDisMissDeelgate> backDelegate;

@property (retain, nonatomic) NSString *title;
@property (nonatomic, retain) DSRequest *requestOjb;
@property (nonatomic, retain) AddressEntity *entiAddress;

@end
