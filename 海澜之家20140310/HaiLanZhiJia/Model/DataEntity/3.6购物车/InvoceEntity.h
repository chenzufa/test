//
//  InvoceEntity.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-12-12.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvoceEntity : NSObject

@property (nonatomic,retain)NSString *strTitle;
@property (nonatomic) BOOL   isNeed;   // 0：要发票   1：不要发票
@property (nonatomic,retain)NSString *strContent;

@end
