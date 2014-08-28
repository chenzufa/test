//
//  ShaiXuanVCViewController.h
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-11-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "SpecEntity.h"

@class ShaiXuanVCViewController;
@protocol ShaiXuanVCDelegate <NSObject>
-(void)object:(ShaiXuanVCViewController*)object shaiXuanArr:(NSArray*)shaiXuanArr;
@end

@interface ShaiXuanVCViewController : CommonViewController
@property(nonatomic,copy)NSString *spId;
@property(nonatomic,assign)id<ShaiXuanVCDelegate>delegate;
@end
