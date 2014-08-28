//
//  SubviewInfoDelegate.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-12-10.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <Foundation/Foundation.h>

//赋值避免类型拿取失败使type值为0，进入到错误的分支
enum InfoType {
    InfoTypeAddress     =1,
    InfoTypeZhiFu       =2,
    InfoTypeDeliver     =3,
    InfoTypeFaPiao      =4,
    InfoTypeXianjin     =5,
    InfoTypeDiyong      =6,
    InfoTypeBeizhu      =7,
    };
@protocol SubviewInfoDelegate <NSObject>

-(void)sendFormMessage:(enum InfoType)type Object:(id)object;

@end
