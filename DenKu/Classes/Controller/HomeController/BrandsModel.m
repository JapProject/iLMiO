//
//  BrandsModel.m
//  ilmio
//
//  Created by MiaoLizhuang on 16/4/26.
//  Copyright © 2016年 com.mitsui-designtec. All rights reserved.
//

#import "BrandsModel.h"

@implementation BrandsModel
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.InteriorPlusCode = [decoder decodeObjectForKey:@"InteriorPlusCode"];
        self.iLMioCode = [decoder decodeObjectForKey:@"iLMioCode"];
    }
    return  self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
   
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.InteriorPlusCode forKey:@"InteriorPlusCode"];
    [encoder encodeObject:self.iLMioCode forKey:@"iLMioCode"];
}

-(id)copyWithZone:(NSZone *)zone
{
    BrandsModel *nModel = [[BrandsModel allocWithZone:zone] init];
    nModel.name = self.name;
    nModel.InteriorPlusCode = self.InteriorPlusCode;
    nModel.iLMioCode = self.iLMioCode;
    
    return nModel;
}


@end
