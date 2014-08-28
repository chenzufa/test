//
//  WatchDog.m
//  UseNetWork
//
//  Created by qianzhenlei on 12-3-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "WatchDog.h"

static WatchDog *_instance = nil;

@implementation WatchDog

@synthesize reachDetector = _reachDetector;
@synthesize isHaveNetwork = _isHaveNetwork;

#pragma mark - System methods
- (void)dealloc
{
    self.reachDetector = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [self initCurrentNewwork];
    }
    
    return self;
}

#pragma mark - Custom methods
- (BOOL)haveNetWork
{
    [self currentInternetStatus];
    return self.isHaveNetwork;
}

+ (WatchDog*)luckDog
{
    if (nil == _instance)
    {
        _instance = [[WatchDog alloc] init];
    }
    
    return _instance;
}

- (void)refrushCurrentNetworkStatus:(Reachability*)currentReach
{
    if ([currentReach isKindOfClass:[Reachability class]])
    {
        NetworkStatus netStatus = [currentReach currentReachabilityStatus];
        
        switch (netStatus)
        {
            case NotReachable:
            {
                self.isHaveNetwork = NO;
//                NSLog(@"WatchDog: no network......");
                if (!_isTellMe)
                {
                    _isTellMe = YES; 
                    _isPushNotification = NO;
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
//                                                                    message:@"当前网络已断开, 请检查网络状况!"
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"知道了" 
//                                                          otherButtonTitles:nil];
//                    [alert show];
//                    [alert release];
//                    [currentReach stopNotifier];
                }
            }
				break;
             case ReachableViaWiFi:
                self.isHaveNetwork = YES;
//                NSLog(@"WatchDog: the network is WiFi...");
                if (!_isPushNotification)
                {
                    _isPushNotification = YES;
                    _isTellMe = NO;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:defHaveNetworkNotification object:nil];
                }
                
                break;
                
            case ReachableViaWWAN:
                self.isHaveNetwork = YES;
//                NSLog(@"WatchDog: the network is 3G...");
                if (!_isPushNotification)
                {
                    _isPushNotification = YES;
                    _isTellMe = NO;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:defHaveNetworkNotification object:nil];
                }
                
                break;
            default:
                break;
        }
    }
}

- (void)currentInternetStatus
{
    [self refrushCurrentNetworkStatus:self.reachDetector];
}

- (void)rechabilityChanged:(NSNotification*)notification
{
    Reachability *currentReach = [notification object];
    [self refrushCurrentNetworkStatus:currentReach];
}

- (void)initCurrentNewwork
{
    self.reachDetector = [Reachability reachabilityForInternetConnection];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(rechabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    [self.reachDetector startNotifier];
    [self currentInternetStatus];
}


@end
