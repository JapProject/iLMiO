

#import "HttpManager+Register.h"

#define ModularKey         @"users"
#define ClassifyKey        @"register"

#define PostKey1        @"birthday"
#define PostKey2        @"sex"
#define PostKey3        @"address"
#define PostKey4        @"building_type"
#define PostKey5        @"device_id"
#define PostKey6        @"device_type"
#define PostKey7        @"push_flg"
#define PostKey8        @"rank_id"

#define ReturnResualt   @"result"
#define ReturnCode      @"error"
#define ReturnMsg       @"msg"
#define ReturnID        @"user_id"

@implementation HttpManager (Register)
- (void)registerNew:(NSString *)birthday
                And:(NSString *)sex
                And:(NSString *)address
                And:(NSString *)buildingType
                And:(NSString *)deviceID
                And:(NSString *)deviceType
                And:(NSString *)pushFlg
                And:(NSString *)rankId
           Finished:(void (^)(BOOL, int, NSString *, NSString *))block
{
#if HttpTest
//    birthday = @"1983-11-11";
//    sex = @"1";
//    address = @"タイトル";
//    buildingType = @"一戸建て";
//    deviceID = @"804ab5b80428f9c41368e2e40de51b2f";
//    deviceType = @"2";
//    pushFlg = @"1";
#endif
    NSString *content = [NSString stringWithFormat:@"&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",
                         PostKey1, birthday,
                         PostKey2, sex,
                         PostKey3, [Common URLEncodedString:address],
                         PostKey4, [Common URLEncodedString:buildingType],
                         PostKey5, [Common URLEncodedString:deviceID],
                         PostKey6, deviceType,
                         PostKey7, pushFlg,
                         PostKey8, [Common URLEncodedString:rankId]];
    ASIFormDataRequest *request = [self getRequestWith:URL
                                               Modular:ModularKey
                                             Operation:ClassifyKey
                                           PostContent:content
                                                  Post:@{PostKey1: birthday,
                                                         PostKey2: sex,
                                                         PostKey3: address,
                                                         PostKey4: buildingType,
                                                         PostKey5: deviceID,
                                                         PostKey6: deviceType,
                                                         PostKey7: pushFlg,
                                                         PostKey8: rankId}];
    [request setDidFinishSelector:@selector(registerNewFinished:)];
    [request setDidFailSelector:@selector(registerNewFailed:)];
    [request setUserInfo:@{@"block":block}];
    [self startAsynchronousWith:request];
}

- (void)registerNewFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dest = [self parserJSON:[request responseString]][ReturnResualt];
    void (^block)(BOOL, int, NSString *, NSString *);
    block = request.userInfo[@"block"];
    block(YES, [dest[ReturnCode] intValue], dest[ReturnMsg], dest[ReturnID]);

}

- (void)registerNewFailed:(ASIHTTPRequest *)request
{
    void (^block)(BOOL, int, NSString *, NSString *);
    block = request.userInfo[@"block"];
    block(NO, 0, nil, nil);
}
@end
