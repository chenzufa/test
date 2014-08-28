//
//  WeiXinShareVC.h
//  Ellassay_iphone
//
//  Created by hua on 12-11-30.
//  Copyright (c) 2012年 donson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface WeiXinEntity : NSObject{
    NSString *_largeimg;
    NSString *_sharetitle;
    NSString *_sharecontent;
    UIImage *_smallimg;
}

@property (nonatomic, retain) NSString *largeimg;
@property (nonatomic, retain) NSString *sharetitle;
@property (nonatomic, retain) NSString *sharecontent;
@property (nonatomic, retain) UIImage *smallimg;

@end


@interface WeiXinShareVC : NSObject

+ (void) shareImg: (WeiXinEntity *)entity;
+ (void) sendImageContent: (NSString *)imgurl thumImg: (UIImage *)image;
+ (void) sendVideo: (WeiXinEntity *)entity;
//朋友圈
+ (void) sendTextContentFiend:(NSString*)nsText;
//回话圈
+ (void) sendTextContentSection:(NSString*)nsText;
@end
