//
//  JsonStringConstructor.m
//  PhonePlus
//
//  Created by wangchaosong on 12-9-11.
//  Copyright (c) 2012年 LongMaster Inc. All rights reserved.
//

#import "JsonStringConstructor.h"

@implementation JsonStringConstructor

NSString* const firstJsonItemFormat = @"\"%@\":\"%@\"";
NSString* const firstComnineItemsFormat = @"\"%@\":%@";
NSString* const newJsonItemFormat = @",\"%@\":\"%@\"";
NSString* const comnineItemsFormat = @",\"%@\":%@";
NSString* const jsonStartFromat = @"{%@";
NSString* const groupJsonStartFromat = @"\"%@\":%@";
NSString* const groupJsonFromat = @",\"%@\":%@";

-(void) pushData:(NSString*) key value:(NSString*) value
{
    //JSON格式:  {"key1":"value1","key2":"value2",...}
    
    if(!jsonString)
    {
        jsonString = [[NSMutableString alloc] init ];
    }
    NSString* newJsonItem = nil;
    if(0 == pushedDataCount)
    {
        if(value.length > 0 && [value characterAtIndex:0] == '[')//是一个组合的json，需要将[和]字符的栓引号去掉
        {
            newJsonItem = [NSString stringWithFormat:firstComnineItemsFormat, key, value];
        }
        else
        {
            newJsonItem = [NSString stringWithFormat:firstJsonItemFormat, key, value];
        }
        [jsonString appendFormat:jsonStartFromat, newJsonItem];
    }
    else
    {
        if(value.length > 0 && [value characterAtIndex:0] == '[')//是一个组合的json，需要将[和]字符的栓引号去掉
        {
            newJsonItem = [NSString stringWithFormat:comnineItemsFormat, key, value];
        }
        else
        {
            
            newJsonItem = [NSString stringWithFormat:newJsonItemFormat, key, value];
        }
        
        [jsonString appendString:newJsonItem];
    }
    pushedDataCount++;
}

-(void) pushDataContents:(NSString*) key value:(NSString*) value isComine:(BOOL)isComine
{
    //JSON格式:  {"key1":"value1","key2":"value2",...}
    
    if(!jsonString)
    {
        jsonString = [[NSMutableString alloc] init ];
    }
    NSString* newJsonItem = nil;
    if(0 == pushedDataCount)
    {
        if(value.length > 0 && [value characterAtIndex:0] == '[')//是一个组合的json，需要将[和]字符的栓引号去掉
        {
            newJsonItem = [NSString stringWithFormat:firstComnineItemsFormat, key, value];
        }
        else
        {
            newJsonItem = [NSString stringWithFormat:firstJsonItemFormat, key, value];
        }
        [jsonString appendFormat:jsonStartFromat, newJsonItem];
    }
    else
    {
        if(value.length > 0 && [value characterAtIndex:0] == '[' && isComine)//是一个组合的json，需要将[和]字符的栓引号去掉
        {
            newJsonItem = [NSString stringWithFormat:comnineItemsFormat, key, value];
        }
        else
        {
            
            newJsonItem = [NSString stringWithFormat:newJsonItemFormat, key, value];
        }
        
        [jsonString appendString:newJsonItem];
    }
    pushedDataCount++;

}

//对组添加。如："list":{"shop":"11","id":"456"}
- (void)pushDataGroup:(NSString *)key value:(NSString *)value
{
    if(!jsonString)
    {
        jsonString = [[NSMutableString alloc] init ];
    }
    NSString* newJsonItem = nil;
    if(0 == pushedDataCount)
    {
        newJsonItem = [NSString stringWithFormat:firstJsonItemFormat, key, value];
        [jsonString appendFormat:jsonStartFromat, newJsonItem];
    }
    else
    {
        
        newJsonItem = [NSString stringWithFormat:groupJsonFromat, key, value];
        
        [jsonString appendString:newJsonItem];
    }
    pushedDataCount++;

}

-(NSString*) getJson
{
    [jsonString appendString:@"}"];
    pushedDataCount = 0;
    return jsonString;
}

//对同一类型的多个JSON进行组合
//attachJsons:需要进行合并的多个JSON
//返回值形似:[{json1},{json2},{json3},...]
-(NSString*) combineJsonsOfSameType:(NSArray*) attachJsons
{
    if(!attachJsons || attachJsons.count == 0)
    {
        return @"";
    }
    NSMutableString* json = [[NSMutableString alloc] init];
    for (NSString* attachJson in attachJsons)
    {
        if(0 == json.length)
        {
            [json appendString:attachJson];
        }
        else
        {
            [json appendFormat:@",%@",  attachJson];
        }
    }
    [json insertString:@"[" atIndex:0];
    [json appendFormat:@"]"];
    return [json autorelease];
}

-(void)dealloc
{
    if(jsonString)
        [jsonString release];
    [super dealloc];
}

@end
