//
//  GouWuCheVC.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-20.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "GouWucheCell.h"
#import "OrderFormVC.h"
#import "SelectGiftVC.h"
#import "DSRequest.h"
#import "ShangPingDetailVC.h"
//#import "LoginViewCtrol.h"

@interface GouWuCheVC : CommonViewController<DSRequestDelegate,UITableViewDataSource,UITableViewDelegate,GouwuCheChangeDelegate,PresentCommitModifyDelegate>

@property (nonatomic,retain)DSRequest   *aRequest;
@property (nonatomic)BOOL isSubview;
@property (nonatomic,retain)UILabel *countLabel;

@end
