
#import "HttpManager+QRCheck.h"
#define ModularKey         @"users"
#define ClassifyKey        @"history_info"

#define PostKey1        @"shop_id"
#define PostKey2        @"brand_id"
#define PostKey3        @"date"
#define PostKey4        @"rank_id"
#define PostKey5        @"time_sort"
//#define PostKey6        @"commission"
//#define PostKey7        @"property_id"
#define PostKey8        @"period"
#define PostKey9        @"sex"
//#define PostKey10       @"area_id"
#define PostKey11       @"medium"
#define PostKey12       @"address"

#define ReturnResualt   @"result"
#define ReturnCode      @"error"
#define ReturnList      @"list"

@implementation HttpManager (QRCheck)
- (void)QRCheck:(NSString *)shopId
            And:(NSString *)brandId
            And:(NSString *)date
            And:(NSString *)timeSlot
            And:(NSString *)rankId
            And:(NSString *)period
            And:(NSString *)sex
            And:(NSString *)Address
            And:(NSString *)medium
       Finished:(void (^)(BOOL, int, QRResualt *))block
{

    NSString *content = [NSString stringWithFormat:@"&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",
                         PostKey1, shopId,
                         PostKey2, brandId,
                         PostKey3, date,
                         PostKey4, [Common URLEncodedString:rankId],
                         PostKey5, timeSlot,
                         PostKey8, period,
                         PostKey9, sex,
                         PostKey11, [Common URLEncodedString:medium],
                         PostKey12, [Common URLEncodedString:Address]];
    ASIFormDataRequest *request = [self getRequestWith:URL
                                               Modular:ModularKey
                                             Operation:ClassifyKey
                                           PostContent:content
                                                  Post:@{PostKey1: shopId,
                                                         PostKey2: brandId,
                                                         PostKey3: date,
                                                         PostKey4: rankId,
                                                         PostKey5: timeSlot,
                                                         PostKey8: period,
                                                         PostKey9: sex,
                                                         PostKey11: medium,
                                                         PostKey12: Address}];
    [request setDidFinishSelector:@selector(QRCheckFinished:)];
    [request setDidFailSelector:@selector(QRCheckFailed:)];
    [request setUserInfo:@{@"block":block}];
    [self startAsynchronousWith:request];
}

- (void)QRCheckFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dest = [self parserJSON:[request responseString]][ReturnResualt];
    void (^block)(BOOL, int, QRResualt *);
    block = request.userInfo[@"block"];
    block(YES, [dest[ReturnCode] intValue], [QRResualt QRResualtWith:dest[ReturnList]]);
}

- (void)QRCheckFailed:(ASIHTTPRequest *)request
{
    void (^block)(BOOL, int, QRResualt *);
    block = request.userInfo[@"block"];
    block(NO, 0, nil);
}

@end
