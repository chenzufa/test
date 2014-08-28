//
//  DesEncryptor.m
//  BI_Client
//
//  Created by caijunbo on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DesEncryptor.h"

@implementation DesEncryptor
+(NSString*)desDecryption:(NSString*)strToDecryption Key:(NSString*)key
{
    
    const char* keyPtr=[key UTF8String];
    NSData* DataToBeConvert=[GTMBase64 decodeBytes:[strToDecryption UTF8String] length:[strToDecryption length]];
    
    size_t numBytesEncrypted = 0;
    
    NSUInteger dataLength = [DataToBeConvert length];
    
    size_t bufferSize = dataLength + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    NSData* output;
    CCCryptorStatus result = CCCrypt( kCCDecrypt, kCCAlgorithmDES, kCCOptionECBMode|kCCOptionPKCS7Padding,
                                     keyPtr, kCCKeySizeDES,
                                     NULL,
                                     [DataToBeConvert bytes], [DataToBeConvert length],
                                     buffer, bufferSize,
                                     &numBytesEncrypted );
    
    
    output=[NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted freeWhenDone:NO];
    if( result == kCCSuccess )
    {
        NSString* strTemp=[[[NSString alloc] initWithData:output encoding:NSUTF8StringEncoding] autorelease];
        free(buffer);
        return strTemp;
    }
    free(buffer);
    return nil;
}

+(NSString*)desEncryption:(NSString*)strToEncryption Key:(NSString*)key
{
    const char* keyPtr=[key UTF8String];
    size_t numBytesEncrypted = 0;
    int dataLength = strlen([strToEncryption UTF8String]);
    
    size_t bufferSize = dataLength + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    CCCryptorStatus result = CCCrypt( kCCEncrypt, kCCAlgorithmDES, kCCOptionECBMode|kCCOptionPKCS7Padding,
                                     keyPtr, kCCKeySizeDES,
                                     NULL,
                                     [strToEncryption UTF8String], strlen([strToEncryption UTF8String]),
                                     buffer, bufferSize,
                                     &numBytesEncrypted );
    
    if( result == kCCSuccess )
    {
        NSData* DataToBeConvert=[GTMBase64 encodeBytes:buffer length:numBytesEncrypted];
        NSString* strTemp=[[[NSString alloc] initWithData:DataToBeConvert encoding:NSUTF8StringEncoding] autorelease];
        free(buffer);
        return strTemp;
    }
    free(buffer);
    return nil;
    
}

@end
