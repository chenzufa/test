//
//  GoodDetailEntity.m
//  HaiLanZhiJia
//
//  Created by donson-周响 on 13-11-27.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "GoodDetailEntity.h"

@implementation GoodDetailEntity
- (void)dealloc
{
    self.shareurl = nil;
    self.goodsname = nil;//商品名称
    self.goodscode = nil;//商品编码
    //self.originprice = nil;//商品原来价格
    //self.currentprice = nil;//商品团购、秒杀价格
    //
    //self.timeleft = nil;//团购、秒杀活动 开始/结束 剩余时间（取决于活动开始与否）
    self.price = nil;//商品价格
    self.size = nil;//商品尺码数组 stringarray
    
    //NSDictionary
    //(key:value)
    //@“color”:	@“商品颜色”
    //@“imgs”:	@“与颜色对应的商品图片”stringArray
    self.colorandimgs = nil;//适合我的护理项目列表
    
    self.imgdetail = nil;//商品详情-图文详情展示页面网址
    
    self.goodsid = nil;//商品id
    
    
    self.sizeandstore = nil;/////////////////尺码库存数组
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.goodsname = [aDecoder decodeObjectForKey:@"goodsname"];
        self.goodscode = [aDecoder decodeObjectForKey:@"goodscode"];
        self.price = [aDecoder decodeObjectForKey:@"price"];
        self.size = [aDecoder decodeObjectForKey:@"size"];
        self.colorandimgs = [aDecoder decodeObjectForKey:@"colorandimgs"];
        self.imgdetail = [aDecoder decodeObjectForKey:@"imgdetail"];
        self.goodsid = [aDecoder decodeObjectForKey:@"goodsid"];
        self.consults = [[aDecoder decodeObjectForKey:@"consults"]intValue];
        self.store = [[aDecoder decodeObjectForKey:@"store"]intValue];
        
        self.savestatus = [[aDecoder decodeObjectForKey:@"savestatus"]intValue];
        self.shareurl = [aDecoder decodeObjectForKey:@"shareurl"];
        self.sizeandstore = [aDecoder decodeObjectForKey:@"sizeandstore"];////////////////////////
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.goodsname forKey:@"goodsname"];
    [aCoder encodeObject:self.goodscode forKey:@"goodscode"];
    [aCoder encodeObject:self.price forKey:@"price"];
    [aCoder encodeObject:self.size forKey:@"size"];
    [aCoder encodeObject:self.colorandimgs forKey:@"colorandimgs"];
    [aCoder encodeObject:self.imgdetail forKey:@"imgdetail"];
    [aCoder encodeObject:self.goodsid forKey:@"goodsid"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.consults] forKey:@"consults"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.store] forKey:@"store"];

    [aCoder encodeObject:[NSString stringWithFormat:@"%d",self.savestatus] forKey:@"savestatus"];
    [aCoder encodeObject:self.shareurl forKey:@"shareurl"];
    
    [aCoder encodeObject:self.sizeandstore forKey:@"sizeandstore"];
}


@end
