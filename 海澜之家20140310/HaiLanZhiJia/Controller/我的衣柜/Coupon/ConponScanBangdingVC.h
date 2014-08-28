//
//  ConponScanBangdingVC.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-3.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "ZBarReaderView.h"
#import "SBJson.h"
#import "DSRequest.h"
@interface ConponScanBangdingVC : CommonViewController<ZBarReaderViewDelegate,DSRequestDelegate>

enum ScanType{
    ScanTypeCash = 1,
    ScanTypeVouchers
};

@property (nonatomic, retain) DSRequest *requestObj;
@property (nonatomic, assign) enum ScanType conponType;
@end
