//
//  UserInfomationVC.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-22.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "UserInfomationCell.h"
#import "SheetChoseCity.h"
#import "CustomerInfoEntity.h"
#import "DSRequest.h"
#import "XmlParser.h"
#import "SheetChooseDate.h"
@protocol UserinformationVCDisMissDelegate <NSObject>

@optional
- (void)userInformationVCDisMissReloadData;

@end

@interface UserInfomationVC : CommonViewController<UITableViewDataSource,UITableViewDelegate,SheetChoseCityDelegate,UserInformationCellTextFieldDelegate,DSRequestDelegate,SheetChooseDateDelegate>

@property (nonatomic, assign) id<UserinformationVCDisMissDelegate> backDelegate;

@property (nonatomic, retain) CustomerInfoEntity *entiCustInfo;
@property (nonatomic, retain) DSRequest *requestOjb;
@end
