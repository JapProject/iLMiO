//
//  NSString_JSONKit.m
//  PhonePlus
//
//  Created by lihuan on 12-11-8.
//  Copyright (c) 2012年 LongMaster Inc. All rights reserved.
//

#import "NSString_JSONKit.h"
#import "JsonKit.h"

@implementation NSString (JSONKit)

/* 将json字符串转化为字典或数组类型。*/
-(id)JSONKitValue{
    return [self mutableObjectFromJSONString];
}

/*
 将json字符串转化为字典或数组类型。
 如果value值存在NSNull类型，在当前字典或数组中增加[key:ExistNSNullValue，value:ExistNSNullValue]键值对。（采用深度查找）
 */
-(id)JSONKitValueForMarkTag{
    id obj=[self mutableObjectFromJSONString];
    if ([obj isKindOfClass:[NSMutableDictionary class]]) {
        [self markTag:obj];
    }
    return obj;
}


/* 将json字符串转化为字典或数组类型。如果value值存在NSNull类型，将该NSNull值改成空字符串@“”。*/
-(id)JSONKitValueFilterNull{
    id obj=[self mutableObjectFromJSONString];
    if ([obj isKindOfClass:[NSMutableDictionary class]]) {
        [self FilterNull:obj];
    }
    return obj;
}



//过滤NSNull值，使之转化为@“”。
-(void)FilterNull:(NSMutableDictionary *)dic{
    for (NSString *key in [dic keyEnumerator]) {
        id obj=[dic objectForKey:key];
        if (obj == [NSNull null]) {
            [dic setValue:@"" forKey:key];
        }
        if ([obj isKindOfClass:[NSArray class]]) {
            for (id _obj in obj) {
                if ([_obj isKindOfClass:[NSMutableDictionary class]]) {
                    [self FilterNull:_obj];
                }
            }
        }
    }
}

//检查是否存在NSNull值。如果存在增加【ExistNSNullValue:ExistNSNullValue】键值对。
-(void)markTag:(NSMutableDictionary *)dic{
    for (NSString *key in [dic keyEnumerator]) {
        id obj=[dic objectForKey:key];
        if (obj == [NSNull null]) {
            [dic setValue:ExistNSNullValue forKey:ExistNSNullValue];
        }
        if ([obj isKindOfClass:[NSArray class]]) {
            for (id _obj in obj) {
                if ([_obj isKindOfClass:[NSMutableDictionary class]]) {
                    [self markTag:_obj];
                }
            }
        }
    }
}

@end
