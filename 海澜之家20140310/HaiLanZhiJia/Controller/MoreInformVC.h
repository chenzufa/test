//
//  MoreInformVC.h
//  HaiLanZhiJia
//
//  Created by creaver on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "MoreCell1.h"
#import "HelpCrnterVC.h"
#import "ContractVC.h"
#import "GetInforVC.h"
#import "AboutUsVC.h"
//
#import "ShareToSinaVC.h"
#import "WeiboApi.h"

//

@interface MoreInformVC : CommonViewController<WeiboAuthDelegate,WeiboAuthDelegate,WeiboRequestDelegate,SinaWeiBoManagerDelegate>
{
    UIActionSheet *mySheet;
}

@property (nonatomic , retain) WeiboApi                    *wbapi;

@property (nonatomic, retain) UIButton *sinaButton; //新浪绑定的按钮
//@property (nonatomic, retain) UIButton *qqButton;   //腾讯绑定按钮
@end
