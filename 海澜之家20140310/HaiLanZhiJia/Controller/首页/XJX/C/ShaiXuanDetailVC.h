//
//  ShaiXuanDetailVC.h
//  HaiLanZhiJia
//
//  Created by xiaojiaxi on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "SpecEntity.h"

@class  ShaiXuanDetailVC;
@protocol ShaiXuanDetailVCDelegate <NSObject>
-(void)object:(ShaiXuanDetailVC*)object value:(SpecEntity*)value;
@end

@interface ShaiXuanDetailVC : CommonViewController
@property(nonatomic,copy)NSArray *shaiXuanArr;
@property(nonatomic,copy)NSString *sxTitle;
@property(nonatomic,assign)id<ShaiXuanDetailVCDelegate>delegate;
@end
