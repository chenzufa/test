//
//  NSDictionary+SafeExtension.m
//  HaiLanZhiJia
//
//  Created by 蒋遂明 on 13-12-28.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "NSDictionary+SafeExtension.h"

@implementation NSDictionary(SafeExtension)

-(NSString *)safeValueForKey:(NSString *)keyStr{
    
    NSString *value = [self valueForKey:keyStr];
    if ([[self valueForKey:keyStr] isKindOfClass:[NSNull class]] || [[self valueForKey:keyStr] isEqual:[NSNull null]]) {
        value = @"";
    }
    return value;
}

@end
