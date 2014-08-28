//
//  DesEncryptor.h
//  BI_Client
//
//  Created by caijunbo on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@interface DesEncryptor : NSObject
+(NSString*)desDecryption:(NSString*)strToDecryption Key:(NSString*)key;
+(NSString*)desEncryption:(NSString*)strToEncryption Key:(NSString*)key;

@end
