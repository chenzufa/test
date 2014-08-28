//
//  GetCityID.m
//  HaiLanZhiJia
//
//  Created by 罗俊宇 on 13-12-25.
//  Copyright (c) 2013年 donson. All rights reserved.
//

#import "GetCityID.h"
#import "XmlParser.h"
@implementation GetCityID

- (id)init
{
    self = [super init];
    if (self) {
        [self initArrays];
    }
    return self;
}

- (void)dealloc
{
//    self.dicsPid = nil;
    [super dealloc];
}

//- (int)getProvinceIDByProvinceName:(NSString *)name
//{
//    
//    return [[self.dicsPid objectForKey:name]intValue];
//}

- (void)initArrays
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *docmentsPath = [self getDocumentDirectoryPath];           //获取沙河目录路径
    NSString *directoryPath = [docmentsPath stringByAppendingPathComponent:@"chooseCity"];  //  新创建的文件夹路径
    NSString *filePath = [directoryPath stringByAppendingPathComponent:@"city.txt"];        //  新创建的文件路径
    
    NSArray *arrProvinces;
    if (![fm fileExistsAtPath:filePath]) {      //判断本地是否有数据文件  没有则解析并生成文件
        
        XmlParser *parser = [[XmlParser alloc]init];  //  xml解析
        arrProvinces = [parser parseByPath:[[NSBundle mainBundle]pathForResource:@"省市区" ofType:@"xml"]];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arrProvinces];
        [fm createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        if ([fm createFileAtPath:filePath contents:data attributes:nil]) {
            NSLog(@" ++++++  yes");
        }else NSLog(@"------- no");
        
        [parser release];
    }else {
        NSData *data = [fm contentsAtPath:filePath];
        arrProvinces = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    NSMutableDictionary *dics = [[NSMutableDictionary alloc]init];      // 将省名跟省ID写进字典中
    for (ProvinceEntity *entiPro in arrProvinces) {
        [dics setObject:entiPro.provinceId forKey:entiPro.provinceName];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:dics forKey:KeyForProvinceID];
    [dics release];
//    arrProvinces = nil;
    
}

- (NSString *)getDocumentDirectoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"documentsDirectory%@",documentsDirectory);
    return documentsDirectory;
}
@end
