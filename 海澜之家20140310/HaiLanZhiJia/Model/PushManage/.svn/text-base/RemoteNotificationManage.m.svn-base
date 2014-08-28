//
//  RemoteNotificationManger.m
//  Mixc
//
//  Created by 陈双龙 on 12-11-20.
//  Copyright (c) 2012年 Donson. All rights reserved.
//

#import "RemoteNotificationManage.h"
#import "RootVC.h"

static RemoteNotificationManage *static_remoteNotificationManage = nil;

@implementation RemoteNotificationManage

+ (RemoteNotificationManage*) sharedRemoteNotificationManage
{
    @synchronized(self){
        if ( nil == static_remoteNotificationManage ) {
            static_remoteNotificationManage = [[RemoteNotificationManage alloc] init];
        }
    }
    
    return static_remoteNotificationManage;
}

- (void) registerNotification;
{
    UIApplication *application = [UIApplication sharedApplication];
    
    application.applicationIconBadgeNumber = 0;
    
    // 让应用支持接收推送消息
    [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | 
                                                     UIRemoteNotificationTypeSound | 
                                                     UIRemoteNotificationTypeAlert)];
}

- (void) failToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
    
}

- (void) registerForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    // 新获取的deviceToken
    NSString* newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 保存当前deviceToken
    self.deviceToken = newToken;
    
    NSLog(@"远程通知DeviceToken:%@",newToken);
    
    [[NSUserDefaults standardUserDefaults] setValue:newToken forKey:kkkDeviceToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) receiveRemoteNotification:(NSDictionary *)userInfo
{
    UIApplication *application = [UIApplication sharedApplication];
    
    application.applicationIconBadgeNumber = 0;
    
    NSLog(@"接收到远程通知:");
    
    int actiontype = -1;
    NSString *str1 = [userInfo objectForKey:@"action_type"]; // 1.打开专题 2.打开商品详情 3.启动程序
    if (![str1 isKindOfClass:[NSNull class]]) {
        actiontype = [str1 intValue];
    }
    
    int specialType = -1;
    NSString *str3 = [userInfo objectForKey:@"specialtype"];  // 0：商品或者启动应用     专题的类型1：宫格 2.瀑布流 3.单图 4.秒杀 5.团购
    if (![str3 isKindOfClass:[NSNull class]]) {
        specialType = [str3 intValue];
    }

    
    int contentID = -1;
    NSString *str2 = [userInfo objectForKey:@"action_type_ext"]; // 1.专题或者商品的id
    if (![str2 isKindOfClass:[NSNull class]]) {
        contentID = [str2 intValue];
    }
        
    switch (actiontype) {
        case 1:
        {
//            SpecialEntity* entity = [[SpecialEntity alloc]init];
//            entity.specialtype = specialType ;
            
            NSString * idString = [NSString stringWithFormat:@"%d",contentID];//专题id
            //专题<=6
            switch (specialType) {
                case 1:
                {
                    //宫格
                    GongGeVC *gongGeView = [[GongGeVC alloc]init];
//                    gongGeView.strTitle = title;
                    gongGeView.zhuanTiId = idString;
                    [[RootVC shareInstance] pushViewController:gongGeView];
                    [gongGeView release];
                }
                    break;
                case 2:
                {
                    //瀑布流
                    HuoDongListVC *puBuLiuView = [[HuoDongListVC alloc]init];
//                    puBuLiuView.strTitle = title;
                    puBuLiuView.zhuantiId = idString;
                    [[RootVC shareInstance] pushViewController:puBuLiuView];
                    
                    [puBuLiuView release];
                }
                    break;
                case 3:
                {
                    //单图
                    SinglePicVC *singleView = [[SinglePicVC alloc]init];
//                    singleView.strTitle = title;
                    singleView.zhuantiId = idString;
                    [[RootVC shareInstance] pushViewController:singleView];
                    [singleView release];
                }
                    break;
                case 4:
                {
                    //秒杀
                    MiaoShaVC *miaoShaView = [[MiaoShaVC alloc]init];
                    miaoShaView.isMiaoSha = YES;
                    miaoShaView.specialId = idString;
                    [[RootVC shareInstance] pushViewController:miaoShaView];
                    [miaoShaView release];
                }
                    break;
                case 5:
                {
                    //团购
                    MiaoShaVC *miaoShaView = [[MiaoShaVC alloc]init];
                    miaoShaView.specialId = idString;
                    miaoShaView.isMiaoSha = NO;
                    [[RootVC shareInstance] pushViewController:miaoShaView];
                    [miaoShaView release];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            ShangPingDetailVC *vc = [[ShangPingDetailVC alloc]init];
            vc.spId = [NSString stringWithFormat:@"%d",contentID];
            [[RootVC shareInstance] pushViewController:vc];
            [vc release];
        }
            break;
        case 3:
        {
            [RootVC shareInstance];
        }
            break;
            
        default:
            break;
    }
    
//    for (id key in userInfo) {
//        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
//    }
    
}
- (void) dealloc
{
    SAFETY_RELEASE(_deviceToken);
    [super dealloc];
}

@end
