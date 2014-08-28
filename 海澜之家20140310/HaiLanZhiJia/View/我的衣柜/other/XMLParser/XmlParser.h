//
//  XmlParser.h
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-5.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProvinceEntity.h"
#import "CityEntity.h"
#import "DistrictEntity.h"
@interface XmlParser : NSObject<NSXMLParserDelegate>

//@property (nonatomic, retain) NSString *strXml;

- (NSArray *)parseByPath:(NSString *)path;

@end
