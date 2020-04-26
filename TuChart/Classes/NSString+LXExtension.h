//
//  NSString+MD5.h
//  YDCube
//
//  Created by Ascen on 2017/7/13.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LXExtension)

#pragma mark - 日期相关

/**
 时间戳转日期 NSString
 
 @param format 日期格式
 @return 日期
 
 */
- (NSString *)lx_timeWithFormat:(NSString *)format;

/** 价格 */
+ (NSString *)lx_price:(NSNumber *)price;

/** 返回加逗号的价格 */
+ (NSString *)lx_commaPrice:(NSString *)price;

/** 返回带单位，并且有逗号的价格 */
+ (NSString *)lx_unitCommaPrice:(NSNumber *)price;

/** 返回带正负号的价格 */
+ (NSString *)lx_signPrice:(NSNumber *)price;

/** 返回带单位(亿、万、万亿)的价格 */
+ (NSString *)lx_unitPrice:(NSNumber *)price;

/** 返回原始位数的价格 */
+ (NSString *)lx_originalPrice:(NSNumber *)price;

// 注册的登录密码是否符合规则
- (BOOL)lx_isPassWordLegal;

+ (NSString *)UUID;

+ (NSString *)eliminateTheScientficForNumber:(NSNumber *)number;

+ (NSString *)getNumberFromStr:(NSString *)str;

@end
