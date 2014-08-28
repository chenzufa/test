//版权所有：版权所有(C) 2013，东信移动控股有限公司
//系统名称：Hi Donson
//文件名称：CustomerURLConnection.m
//作　　者：蔡俊波
//完成日期：2013-09-4
//功能说明：接口数据请求连接类（自定义NSURLConnection）
//-----------------------------------------
#import "CustomerURLConnection.h"

@implementation CustomerURLConnection
@synthesize bufData,requestType,requestTag,strRequestKey;

-(id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate
{
    self=[super initWithRequest:request delegate:delegate];
    if (self) {
        bufData=[[NSMutableData alloc] init];
    }
    return self;
}
-(void)dealloc
{
    self.strRequestKey=nil;
    [bufData release];
    [super dealloc];
}

@end
