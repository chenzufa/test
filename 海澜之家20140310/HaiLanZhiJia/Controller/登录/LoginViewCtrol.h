//
//  LoginViewCtrol.h
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-21.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "WCAlertView.h"
#import "ForgetViewVC.h"
#import "AppDelegate.h"
//#import "SinaWeibo.h"
#import "SinaWeiBoManager.h"
#import "AlixPay.h"
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "DataSigner.h"

#import "DSRequest.h"

#import "RegisterLoginEntity.h"

@protocol LoginViewCtrolDisMissDelegate <NSObject>

@optional
- (void)loginViewCtrolDisMissed;

@end

@interface LoginViewCtrol : CommonViewController<TencentLoginDelegate,TencentSessionDelegate,DSRequestDelegate,SinaWeiBoManagerDelegate>
{
    TencentOAuth* _tencentOAuth;
    NSArray * _permissions;
}

@property (nonatomic, assign) id <LoginViewCtrolDisMissDelegate> backDelegate;

@end
