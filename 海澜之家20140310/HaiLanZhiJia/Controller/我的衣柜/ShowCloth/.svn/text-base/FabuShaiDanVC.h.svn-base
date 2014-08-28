//
//  FabuShaiDanVC.h
//  HaiLanZhiJia
//
//  Created by chenzufa on 13-12-2.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "CommonViewController.h"
#import "DSRequest.h"

@protocol FabuShaiDanVCDelegate <NSObject>

- (void)fabuSuccessed;

@end

@interface FabuShaiDanVC : CommonViewController<DSRequestDelegate>

@property(nonatomic , retain)UITextField* titleTextField;
@property(nonatomic , retain)DSRequest* uploadRequest;
@property(nonatomic , retain)NSString* goodID;
@property(nonatomic , retain)id<FabuShaiDanVCDelegate>delegate;
@property(nonatomic , retain)NSString* sizeAndColor;
@property(nonatomic , retain)NSString* orderID;
@end
