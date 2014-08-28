//
//  XmlParser.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-5.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "XmlParser.h"

@implementation XmlParser
{
    NSString *currentString;
    NSMutableArray *provinces;
    ProvinceEntity *province;
    CityEntity *city;
    DistrictEntity *district;
    
    int mark;  // 0省  1城市 2区
}

- (void)dealloc
{
    [provinces release];
    
    province = nil;
    city = nil;
    district = nil;
    currentString = nil;
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSArray *)parseByPath:(NSString *)path
{
    NSData *data=[NSData dataWithContentsOfFile:path];
    NSXMLParser *parser=[[[NSXMLParser alloc]initWithData:data]autorelease];
    parser.delegate=self;
    provinces=[[NSMutableArray alloc]init];
    //    开始解析
    [parser parse];
    return [provinces copy];
    
    
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
//    NSLog(@"name=%@",elementName);
    if ([elementName isEqualToString:@"province"]) {
        if (province) {
            province = nil;
        }
        province =[[ProvinceEntity alloc]init];
        province.arrCitys = [NSMutableArray array];
        mark = 0;
    }else if ([elementName isEqualToString:@"city"]) {
        if (city) {
            city = nil;
        }
        city =[[CityEntity alloc]init];
        city.arrDistricts = [NSMutableArray array];
        mark = 1;
    }else if ([elementName isEqualToString:@"district"]) {
        if (district) {
            district = nil;
        }
        district =[[DistrictEntity alloc]init];
        mark = 2;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    currentString =[string retain];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    switch (mark) {
        case 0:
            if ([elementName isEqualToString:@"name"]) {
                province.provinceName = currentString;
            } else if([elementName isEqualToString:@"provinceid"]) {
                province.provinceId = currentString;
            } else if([elementName isEqualToString:@"province"]) {
                ProvinceEntity *p = [[ProvinceEntity alloc]init];
                p = province;
                //NSLog(@"%@",p.provinceName);
                [provinces addObject:p];
                [p release];
            }
            break;
        case 1:
            if ([elementName isEqualToString:@"name"]) {
                city.cityName = currentString;
            } else if([elementName isEqualToString:@"cityid"]) {
                city.cityId = currentString;
            } else if([elementName isEqualToString:@"city"]) {
                CityEntity *c = [[CityEntity alloc]init];
                c = city;
                //NSLog(@"%@",c.cityName);
                [province.arrCitys addObject:c];
                [c release];
                mark = 0;
            }
            break;
        case 2:
            if ([elementName isEqualToString:@"name"]) {
                district.districtName = currentString;
            } else if([elementName isEqualToString:@"districtid"]) {
                district.districtId = currentString;
            } else if([elementName isEqualToString:@"district"]) {
                DistrictEntity *d = [[DistrictEntity alloc]init];
                d = district;
                //NSLog(@"%@",d.districtName);
                [city.arrDistricts addObject:d];
                mark = 1;
                [d release];
            }
            break;
            
        default:
            break;
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
// NSLog(@"parserDidEndDocument %@",NSStringFromSelector(_cmd) );
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
//    NSLog(ß®@"foundCDATA %@",NSStringFromSelector(_cmd) );
}

@end
