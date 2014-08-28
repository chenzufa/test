//
//  OrderDetailVC.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-4.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "DSRequest.h"
#import "PayMentVC.h"

@protocol PaySuccessedDelegate <NSObject>

@optional
- (void)payDidSuccess;

@end

@interface OrderDetailVC : CommonViewController<UITableViewDataSource,UITableViewDelegate,DSRequestDelegate,UIActionSheetDelegate,SubviewInfoDelegate>

enum OrderType{
    OrderTypeGoing,
    OrderTypeFinished,
    orderTypeNoService
};

@property (nonatomic, retain) DSRequest *requestOjb;
@property (nonatomic, retain) NSString *orderNum;
@property (nonatomic, retain) OrderDetailEntity *entiOrderDetail;
@property (nonatomic, assign) enum OrderType odType;
@property (nonatomic, assign) int paystatus;
@property (nonatomic, assign) id<PaySuccessedDelegate>payDelegate;
@end
