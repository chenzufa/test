//
//  NSObject+ToolClass.h
//  NYGWIpad
//
//  Created by donsonsz donson on 12-9-12.
//  Copyright (c) 2012年 donson. All rights reserved.
//

#import <Foundation/Foundation.h>


// 程序全局开关控制

#pragma mark    ——SWITCHES 开关控制——

#define DES_CODE 1                            //DES 加密 0:不加密  1:加密
#define IS_HAILANZHIJIA_ENVIRONMENT    1      // 1：使用海澜服务器 0: 使用东信服务器



#pragma mark    ——常用宏定义——

//设置字体为华文中宋和对应的字体大小
//#define YHFont(x) [UIFont fontWithName:@"Microsoft YaHei" size:x]
#define YHFont(x) [UIFont systemFontOfSize:(x)]
#define SYSTEMFONT(x) [UIFont systemFontOfSize:(x)]
#define SYSTEMBOLDFONT(x) [UIFont boldSystemFontOfSize:(x)]
#define Font_HelveticaInSize(a) [UIFont fontWithName:@"Helvetica" size:(a)]
typedef enum{
    kWBRequestPostDataTypeNone,
	kWBRequestPostDataTypeNormal,		// for normal data post, such as "user=name&password=psd"
	kWBRequestPostDataTypeMultipart,    // for uploading images and files.
}WBRequestPostDataType;

/**
 @method 取本地plist
 @param  NSString
 @return NSDictionary
 */
#define GETLOCALPLIST(fileName)[[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"]] autorelease]

// 检测 NSString 对象是否为空
#define isStringEmputy(x) (!x || [x isKindOfClass:[NSNull class]] || [x isEqualToString:@""])

//获取本地图片的路径
#define GETIMG(name) [UIImage imageNamed:name]
//两倍图片没有加@2x 求宽高
#define GetImageHeight(image)  (image.size.height/2.0)
#define GetImageWidth(image)  (image.size.width/2.0)

// 判断是否为iphone5
#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// 是否为高清屏
#define isRetina ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&([UIScreen mainScreen].scale == 2.0))
//版本号
#define DeviceVision [[[UIDevice currentDevice] systemVersion] floatValue]
//判断版本号大于7
#define isBigeriOS7version [[[UIDevice currentDevice]systemVersion]floatValue]>=7.0

// 主界面宽，高
#define MainViewWidth   [[UIScreen mainScreen] bounds].size.width
#define MainViewHeight  [[UIScreen mainScreen] bounds].size.height
//获取屏幕
#define MainScreen [[UIScreen mainScreen] bounds]
// 底部工具条高度
#define BOTTOMHEIGHT 45
// 标题高度
#define TITLEHEIGHT     45
// 内容所占高度
#define CONTENTHEIGHT   (MainViewHeight-BOTTOMHEIGHT-20)
#define CONTENTFRAME    CGRectMake(0, 0, MainViewWidth, CONTENTHEIGHT)
//屏幕宽度
#define SELFVCFRAMEWITH self.view.frame.size.width
#define SELFVIEWFRAMEWIDTH self.frame.size.width
//屏幕高度
#define SELFVCFRAMEHEIGHT self.view.frame.size.height
#define SELFVIEWFRAMEHEIGHT self.frame.size.height

// 安全释放
#define SAFETY_RELEASE(x)   {[(x) release]; (x)=nil;}


// color RGB
//RGB 颜色
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]
#define CGRGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1].CGColor
//本项目常用的颜色
#define TEXT_GRAY_COLOR RGBCOLOR(47,47,47)
#define TEXT_BLUE_COLOR RGBCOLOR(29,20,92)
//#define TEXT_RED_COLOR  RGBCOLOR(178,32,31)
#define TEXT_RED_COLOR  RGBCOLOR(239,0,27)
#define TEXT_BACKGROUD_COLOR  RGBCOLOR(247,247,247)
#define VIEW_BACKGROUND_COLOR RGBCOLOR(245,245,245)
#define SUBTITLE_GRAY_COLOR RGBCOLOR(101,101,101)

// 颜色和尺码字体的颜色
#define ColorAndSize [UIColor colorWithRed:0.604 green:0.588 blue:0.588 alpha:1]

//检测网络
#define defHasNetWork [[WatchDog luckDog] haveNetWork]
#define defAlertNetWork { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前网络异常,请检查网络！" delegate:nil cancelButtonTitle:@"确定"otherButtonTitles:nil, nil]; [alert show]; [alert release]; }


#define GetImage(name)  [UIImage imageNamed:name]
#define SetFontSize(s) [UIFont systemFontOfSize:s]

#define FontSize15 15
#define FontSize10 10
#define FontSize12 12

//海澜之家出现次数比较多的几种颜色
#define ColorFontBlack [UIColor colorWithRed:0.243 green:0.243 blue:0.243 alpha:1]
#define ColorFontBlue [UIColor colorWithRed:0.043 green:0.231 blue:0.603 alpha:1]
#define ColorFontRed [UIColor colorWithRed:0.698 green:0.126 blue:0.122 alpha:1]
#define ColorFontgray [UIColor colorWithRed:0.604 green:0.588 blue:0.588 alpha:1]

//腾讯微博
#define WiressSDKDemoAppKey     @"801213517"
#define WiressSDKDemoAppSecret  @"9819935c0ad171df934d0ffb340a3c2d"
#define REDIRECTURI             @"http://www.ying7wang7.com"
//新浪微博
#define kAppKey             @"552828054"
#define kAppSecret          @"281e22dafe1b08761d8e2ddbaf69ed3c"
#define kAppRedirectURI     @"http://www.sina.com"
#define SinaToken @"sinaToken"
#define SinaUserId @"sinaUserId"
#define SinaWeiboAuthData @"SinaWeiboAuthData"  //新浪微博储存数据的key
//微信
#define weiXinApi @"wxf7787aeb11542efa"
//QQ
#define QQApi @"100413365"


//购物车物品数量
#define kGouWuCheGoodsCount @"GouWuCheGoodsCount"
#define kRequestFailMessage @"服务器维护中,请稍后再试!"

//通用的提示信息
#define Loading @"加载中..."
#define LoadingFailed @"无法连接服务器"
#define LoadingSuccess @"加载成功"

//登陆和注册后保存的id和token的key
#define UserId @"userId"
#define Token    @"token"
//匿名id
#define AnonymityId @"anonymityId"


//保存远程推送的deviceToken
#define kkkDeviceToken               @"kkkDeviceTokenhaiLanZhiJia"

//区扫描历史的key
#define ScanHistory @"ScanHistory"

//搜索没结果，点击 继续逛逛 时发送的通知
#define kJiXuGuangGuangNotification @"JiXuGuangGuangNotification"
//咨询提交成功后返回前一页面时发的通知，提醒刷新界面
#define kZiXunSuccessNotification @"ZiXunSuccessNotification"
//搜索没结果，点击 继续逛逛 时发送的通知
#define kSPDetailShopCarClickedNotification @"SPDetailShopCarClickedNotification"

//登录成功的通知(非自动)
#define LoginSuccess @"loginSuccess"
//注销登录的通知
#define LoginOut @"loginOut"
//存储省id的key
#define KeyForProvinceID @"keyForProvinceID"

//存储当前省id的key
#define KeyCurrentProvinceID @"keyCurrentForProvinceID"

//查看订单提醒后发出通知
#define OrderRedRemind @"OrderRedRemind"

//  延迟网络请求时间
#define RequestTime 0.1 
//刷新延迟时间
#define RefresDelayTime 3.0f

// 刷新购物车
#define ReloadGouwuche @"ReloadGouWuChe"

// 支付宝支付成功后发出通知
#define ZhifubaoSuccess @"ZhifubaoSuccess"
