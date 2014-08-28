//版权所有：版权所有(C) 2013，东信移动控股有限公司
//系统名称：Hi Donson
//文件名称：CustomerURLConnection.h
//作　　者：蔡俊波
//完成日期：2013-09-4
//功能说明：接口数据请求连接类（自定义NSURLConnection）
//-----------------------------------------

#import <Foundation/Foundation.h>
#import "InterfaceConstant.h"

@interface CustomerURLConnection : NSURLConnection
{
    NSMutableData* bufData;
    enum InterfaceType requestType;
    int requestTag;
    NSString* strRequestKey;
}
@property(nonatomic,assign) NSMutableData* bufData;
@property(nonatomic,assign) enum InterfaceType requestType;
@property(nonatomic,assign) int requestTag;

@property(nonatomic,retain) NSString* strRequestKey;

@end
