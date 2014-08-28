//
//  ForgetViewVC.h
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-22.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "MySegMentControl.h"
#import "WCAlertView.h"
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>

#import "DSRequest.h"
@interface ForgetViewVC : CommonViewController<MYSegMentControlDelegate,UITextFieldDelegate,DSRequestDelegate>


@property (nonatomic,retain)DSRequest   *aRequest;
@end
