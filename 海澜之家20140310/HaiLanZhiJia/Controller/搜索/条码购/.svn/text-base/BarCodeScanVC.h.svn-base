//
//  BarCodeScanVC.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "MySegMentControl.h"
#import "ZBarReaderView.h"
#import "SBJson.h"
#import "DSRequest.h"
//#import "ShangPingDetailVC.h"
#import "ScanHistoryVC.h"
@interface BarCodeScanVC : CommonViewController<MYSegMentControlDelegate,ZBarReaderViewDelegate,DSRequestDelegate,UIAlertViewDelegate,ScanHistroyVCDisMissDelegate>

@property (nonatomic, retain) DSRequest *requestOjb;
@property (nonatomic, retain) NSMutableArray *arrScanHistory;  //存储扫描到的结果
@end
