//
//  SinaWeiBoManager.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 14-4-14.
//  Copyright (c) 2014年 donson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"
@class SinaWeiBoManager;
@protocol SinaWeiBoManagerDelegate <NSObject>

@optional
- (void)sinaWeiBoManagerDidLoginGetToken:(NSString *)accessToken userId:(NSString *)userID expirationDate:(NSDate *)expirationDate;

@end

@interface SinaWeiBoManager : NSObject<WeiboSDKDelegate,WBHttpRequestDelegate>

@property (nonatomic, assign) id<SinaWeiBoManagerDelegate> delegate;

+ (SinaWeiBoManager *)sharedInstance;

- (void)sinaLogin;      //授权登录
- (void)sinalogout;     //注销
- (void)shareMessageToSinaWithText:(NSString *)text imageUrlStr:(NSString *)imageurlstr;    //分享到微博
@end
