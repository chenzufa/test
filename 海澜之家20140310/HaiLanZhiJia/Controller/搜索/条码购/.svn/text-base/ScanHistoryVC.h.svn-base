//
//  ScanHistoryVC.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
@class ScanHistoryVC;
@protocol ScanHistroyVCDisMissDelegate <NSObject>

@optional
- (void)scanHistroyVCDisMissed:(ScanHistoryVC *)scanHistroyvc;

@end

@interface ScanHistoryVC : CommonViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (nonatomic, assign) id <ScanHistroyVCDisMissDelegate> backDelegate;
@end
