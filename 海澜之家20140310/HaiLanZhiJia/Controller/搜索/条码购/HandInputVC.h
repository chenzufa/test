//
//  HandInputVC.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "DSRequest.h"
#import "ShangPingDetailVC.h"
@interface HandInputVC : CommonViewController<DSRequestDelegate,UIAlertViewDelegate>

@property (nonatomic, retain) DSRequest *requestOjb;

@end
