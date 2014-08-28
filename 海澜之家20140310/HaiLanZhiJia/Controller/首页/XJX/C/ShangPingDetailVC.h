//
//  ShangPingDetailVC.h
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-26.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "WXApi.h"
#import "GoodDetailEntity.h"

#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
//#import "SinaWeibo.h"
#import "WeiboApi.h"
#import "WeiXinShareVC.h"
#import "ShareToSinaVC.h"

typedef enum
{
    ComeFromLieBiao=0,
    ComeFromTiaoMa=1
}ComeFromType;

@protocol ShangPingDetailVCDelegate <NSObject>
@optional
-(void)comeBackFromSpDetailVC;
@end

@interface ShangPingDetailVC : CommonViewController
@property(nonatomic,retain)GoodDetailEntity  *spDetailObject;
@property(nonatomic,assign)NSString *spId;
@property(nonatomic,retain)GoodEntity *shopCarGoodEntity;
@property(nonatomic,retain)WeiboApi  *wbapi;
@property(nonatomic,assign)ComeFromType comeFromType;
@property(nonatomic,assign)id<ShangPingDetailVCDelegate>delegate;
@end
