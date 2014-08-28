//
//  WatchDog.h
//  UseNetWork
//
//  Created by qianzhenlei on 12-3-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"

#define defHaveNetworkNotification @"defHaveNetworkNotification"

@interface WatchDog : NSObject 
{
    Reachability *_reachDetector;
    BOOL         _isHaveNetwork;
    BOOL         _isTellMe;
    BOOL         _isPushNotification;
}

@property (nonatomic, retain) Reachability *reachDetector;
@property BOOL         isHaveNetwork;


+ (WatchDog*)luckDog;
- (BOOL)haveNetWork;

@end
