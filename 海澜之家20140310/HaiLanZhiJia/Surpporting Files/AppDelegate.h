//
//  AppDelegate.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-11-20.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnimationsView.h"
#import "GuideAdVC.h"
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import "WXApi.h"
#import "DSRequest.h"
#import "MobClick.h"
#import "WeiboSDK.h"
//@class SinaWeibo;
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,AnimationsViewDelegate,DSRequestDelegate,WeiboSDKDelegate>{
    AnimationsView *_actionView;
//    UIImageView *view ;
}

@property (strong, nonatomic) UIWindow *window;
//@property (retain, nonatomic) SinaWeibo *sinaweibo;
@property(nonatomic,retain)NSString *dateStr;

@property (retain, nonatomic) WeiboApi *wbapi;
@property (nonatomic, retain) DSRequest *requestLjy;
@end
