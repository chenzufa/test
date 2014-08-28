//
//  UIViewController+Hud.h
//  MeiLiYun
//
//  Created by xiaojiaxi on 13-10-25.
//  Copyright (c) 2013年 com.donson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExtend.h"
#import "DSRequest.h"
#define HudText @"加载中..."
@interface UIViewController (Hud)<DSRequestDelegate>
-(void)addHud:(NSString*)text;
-(void)addHudNM:(NSString*)text;
-(void)hideHud:(MBProgressHUD*)hud;
-(void)addFadeLabel:(NSString*)text;
@end
