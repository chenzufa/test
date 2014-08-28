//
//  RemoteNotificationManger.h
//  Mixc
//
//  Created by 陈双龙 on 12-11-20.
//  Copyright (c) 2012年 Donson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoteNotificationManage : NSObject
@property (nonatomic, copy) NSString *deviceToken;

// 获得推送管理对象
+ (RemoteNotificationManage*) sharedRemoteNotificationManage;

// 注册推送通知
- (void) registerNotification;

// 注册失败
- (void) failToRegisterForRemoteNotificationsWithError:(NSError*)error;

// 注册成功
- (void) registerForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken;

// 接收到远程通知
- (void) receiveRemoteNotification:(NSDictionary *)userInfo;

@end
