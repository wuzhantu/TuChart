//
//  NSString+MD5.m
//  YDCube
//
//  Created by Ascen on 2017/7/13.
//  Copyright © 2017年 Ascen. All rights reserved.
//

#import "NSString+LXExtension.h"
#import "CommonCrypto/CommonDigest.h"

@implementation NSString (LXExtension)

- (NSString *)lx_timeWithFormat:(NSString *)format
{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self longLongValue]]];
    
    return currentDateStr;
}

+ (NSString *)lx_price:(NSNumber *)price {
    /*
     if (!price) return @"--";
     if (price.doubleValue > 0.1 ||
         price.doubleValue < -0.1 || price.doubleValue == 0.0) {
         return [NSString stringWithFormat:@"%.2f", price.doubleValue];
     } else if (price.doubleValue > 0.0001 ||
     price.doubleValue < -0.0001) {
     return [NSString stringWithFormat:@"%.4f", price.doubleValue];
     } else if (price.doubleValue > 0.000001 ||
     price.doubleValue < -0.00001) {
     return [NSString stringWithFormat:@"%.6f", price.doubleValue];
     } else {
     return [NSString stringWithFormat:@"%.8f", price.doubleValue];
     }
     */
    if (!price) return @"--";
    if (price.doubleValue > 1 ||
        price.doubleValue < -1  || price.doubleValue == 0.0) {
        return [NSString stringWithFormat:@"%.2f", price.doubleValue];
    }
    else if (price.doubleValue > 0.1 ||
        price.doubleValue < -0.1) {
        return [NSString stringWithFormat:@"%.4f", price.doubleValue];
    }
    else if (price.doubleValue > 0.01 ||
               price.doubleValue < -0.01) {
        return [NSString stringWithFormat:@"%.5f", price.doubleValue];
    }
    else if (price.doubleValue > 0.001 ||
             price.doubleValue < -0.001) {
        return [NSString stringWithFormat:@"%.6f", price.doubleValue];
    }
    else if (price.doubleValue > 0.0001 ||
               price.doubleValue < -0.0001) {
        return [NSString stringWithFormat:@"%.7f", price.doubleValue];
    }
    else if (price.doubleValue > 0.00001 ||
             price.doubleValue < -0.00001) {
        return [NSString stringWithFormat:@"%.8f", price.doubleValue];
    }
    else if (price.doubleValue > 0.000001 ||
               price.doubleValue < -0.00001) {
        return [NSString stringWithFormat:@"%.9f", price.doubleValue];
    }
    else {
        return [NSString stringWithFormat:@"%.8f", price.doubleValue];
    }
}

+ (NSString *)lx_signPrice:(NSNumber *)price {
    if (!price) return @"--";
    if (price.doubleValue > 0.0) {
        if (price.doubleValue > 0.1) {
            return [NSString stringWithFormat:@"%.2f", price.doubleValue];
        } else if (price.doubleValue > 0.0001) {
            return [NSString stringWithFormat:@"%.4f", price.doubleValue];
        } else if (price.doubleValue > 0.000001) {
            return [NSString stringWithFormat:@"%.6f", price.doubleValue];
        } else {
            return [NSString stringWithFormat:@"%.8f", price.doubleValue];
        }
    } else {
        if (price.doubleValue < -0.1) {
            return [NSString stringWithFormat:@"%.2f", price.doubleValue];
        } else if (price.doubleValue < -0.0001) {
            return [NSString stringWithFormat:@"%.4f", price.doubleValue];
        } else if (price.doubleValue < -0.00001) {
            return [NSString stringWithFormat:@"%.6f", price.doubleValue];
        } else {
            return [NSString stringWithFormat:@"%.8f", price.doubleValue];
        }
    }
}

+ (NSString *)lx_commaPrice:(NSString *)price {
    if (!price) return @"--";
    NSString *intStr;
    NSString *floStr;
    
    if ([price containsString:@"."]) {
        NSRange range = [price rangeOfString:@"."];
        floStr = [price substringFromIndex:range.location];
        intStr = [price substringToIndex:range.location];
    } else {
        floStr = @"";
        intStr = price;
    }
    
    if (intStr.length <=3) {
        return [intStr stringByAppendingString:floStr];
    } else {
        NSInteger length = intStr.length;
        NSInteger count = length/3;
        NSInteger y = length%3;
        NSString *tit = [intStr substringToIndex:y] ;
        NSMutableString *det = [[intStr substringFromIndex:y] mutableCopy];
        for (int i =0; i < count; i ++) {
            NSInteger index = i + i *3;
            [det insertString:@","atIndex:index];
        }
        
        if (y ==0) {
            det = [[det substringFromIndex:1]mutableCopy];
        }
        
        intStr = [tit stringByAppendingString:det];
        return [intStr stringByAppendingString:floStr];
    }
}

+ (NSString *)lx_unitCommaPrice:(NSNumber *)price {
    if (!price) return @"--";
    if (price.longValue > 100000000) {
        return [[NSString lx_commaPrice:[NSString stringWithFormat:@"%.2lf", price.doubleValue / 100000000]] stringByAppendingString:@"亿"];
    } else if (price.longValue > 10000) {
        return [[NSString lx_commaPrice:[NSString stringWithFormat:@"%.2lf", price.doubleValue / 10000]] stringByAppendingString:@"万"];
    } else {
        return [NSString lx_commaPrice:[NSString stringWithFormat:@"%.2f", price.doubleValue]];
    }
}

+ (NSString *)lx_unitPrice:(NSNumber *)price {
    if (!price) return @"--";
    if (price.doubleValue > 0.1) {
        if (price.doubleValue > 1000000000000) {
            return [NSString stringWithFormat:@"%.2f万亿", price.doubleValue / 1000000000000];
        } else if (price.doubleValue > 100000000) {
            return [NSString stringWithFormat:@"%.2f亿", price.doubleValue / 100000000];
        } else if (price.doubleValue > 10000){
            return [NSString stringWithFormat:@"%.2f万", price.doubleValue / 10000];
        } else {
            return [self lx_price:price];
        }
    } else if (price.doubleValue < -0.1) {
        double priceO = fabs(price.doubleValue);
        if (priceO > 1000000000000) {
            return [NSString stringWithFormat:@"-%.2f万亿", priceO / 1000000000000];
        } else if (priceO > 100000000) {
            return [NSString stringWithFormat:@"-%.2f亿", priceO / 100000000];
        } else if (priceO > 10000){
            return [NSString stringWithFormat:@"-%.2f万", priceO / 10000];
        } else {
            return [self lx_price:[NSNumber numberWithDouble:priceO]];
        }
    }
    return [NSString lx_price:price];
}


+ (NSString *)lx_originalPrice:(NSNumber *)price {
    if (!price) return @"--";
    if (![price isKindOfClass:NSNumber.class]) return @"";
    NSString *priceStr = [NSString stringWithFormat:@"%.12f", price.doubleValue];
    // 去掉后面的0
    while (priceStr.length > 1 && [[priceStr substringFromIndex:priceStr.length - 1] isEqual: @"0"]) {
        priceStr = [priceStr substringToIndex:priceStr.length - 1];
    }
    
    if ([priceStr containsString:@"."]) {
        // 如果大于8位
        NSRange range = [priceStr rangeOfString:@"."];
        NSString *floStr = [priceStr substringFromIndex:range.location + range.length];
        while (floStr.length > 8) {
            floStr = [floStr substringToIndex:floStr.length - 1];
        }
        // 再去掉后面的0
        while (floStr.length > 1 && [[floStr substringFromIndex:floStr.length - 1] isEqual: @"0"]) {
            floStr = [floStr substringToIndex:floStr.length - 1];
        }
        NSString *intStr = [priceStr substringToIndex:range.location];
        return floStr.length > 0 ? [NSString stringWithFormat:@"%@.%@", intStr, floStr] : intStr;
    }
    return priceStr;
}

- (BOOL)lx_isPassWordLegal {
    BOOL result = false;
    if ([self length] >= 6 && [self length] <= 24){
        // 判断长度大于8位后再接着判断是否同时包含数字和字符
        NSString * regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,24}$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        result = [pred evaluateWithObject:self];
    }
    return result;
}


+ (NSString *)UUID {
    CFUUIDRef uuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, uuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(uuid);
    CFRelease(uuidString);
    return result;
}

+ (NSString *)eliminateTheScientficForNumber:(NSNumber *)number {
    NSNumberFormatter *nf = NSNumberFormatter.new;
    //nf.numberStyle = NSNumberFormatterDecimalStyle;
    nf.positiveFormat = @"#.##########"; // 自定义格式
    NSString *string = [nf stringFromNumber:number];
    //NSLog(@"number=%@", number);
    //NSLog(@"string=%@", string);
    return string;
}

+ (NSString *)getNumberFromStr:(NSString *)str {
    NSCharacterSet *nonDigitCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    //return [[str componentsSeparatedByCharactersInSet:nonDigitCharacterSet] componentsJoinedByString:@""];
    //NSCharacterSet *digitCharacterSet = NSCharacterSet.decimalDigitCharacterSet;
    return [str stringByTrimmingCharactersInSet:nonDigitCharacterSet];
}

@end
