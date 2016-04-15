//
//  JsonStringConstructor.h
//  PhonePlus
//
//  Created by wangchaosong on 12-9-11.
//  Copyright (c) 2012年 LongMaster Inc. All rights reserved.
//
//JSON字符串构造器

#import <Foundation/Foundation.h>

@interface JsonStringConstructor : NSObject
{
    int pushedDataCount;
    NSMutableString* jsonString;
}

-(void) pushData:(NSString*) key value:(NSString*) value;
-(void) pushDataContents:(NSString*) key value:(NSString*) value isComine:(BOOL)isComine;

//对组添加。如："list":{"shop":"11","id":"456"}
- (void)pushDataGroup:(NSString *)key value:(NSString *)value;

-(NSString*) getJson;

//对同一类型的多个JSON进行组合
//attachJsons:需要进行合并的多个JSON
//返回值形似:[{json1},{json2},{json3},...]
-(NSString*) combineJsonsOfSameType:(NSArray*) attachJsons;

@end
