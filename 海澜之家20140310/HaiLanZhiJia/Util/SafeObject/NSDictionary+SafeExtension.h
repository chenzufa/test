//
//  NSDictionary+SafeExtension.h
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-12-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary(SafeExtension)

- (NSString *)safeValueForKey:(NSString *)keyStr;

@end
