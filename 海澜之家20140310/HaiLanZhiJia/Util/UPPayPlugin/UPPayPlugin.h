//
//  UPPayPluginEx.h
//  UPPayPluginEx
//
//  Created by wxzhao on 12-10-10.
//  Copyright (c) 2012年 China UnionPay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UPPayPluginDelegate.h"

#define kWaiting          @"正在与银联交易,请稍后..."
#define kNote             @"提示"
#define kConfirm          @"确定"
#define kErrorNet         @"网络错误"
#define kResult           @"支付结果：%@"

#define kMode @"01"
//tn 交易流水号  mode 00正式环境 01测试环境
@interface UPPayPlugin : NSObject

+ (BOOL)startPay:(NSString*)tn mode:(NSString*)mode viewController:(UIViewController*)viewController delegate:(id<UPPayPluginDelegate>)delegate;


@end
