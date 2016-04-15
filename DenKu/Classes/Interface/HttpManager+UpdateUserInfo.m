
#import "HttpManager+UpdateUserInfo.h"

#define ModularKey         @"users"
#define ClassifyKey        @"update_user_info"

#define PostKey1        @"user_id"
#define PostKey2        @"birthday"
#define PostKey3        @"sex"
#define PostKey4        @"address"
#define PostKey5        @"building_type"
#define PostKey6        @"device_id"
#define PostKey7        @"device_type"
#define PostKey8        @"push_flg"
#define PostKey9        @"rank_id"

#define ReturnResualt   @"result"
#define ReturnList      @"list"
#define ReturnCode      @"error"
#define ReturnMsg       @"msg"

@implementation HttpManager (UpdateUserInfo)
- (void)updateUserINfo:(NSString *)userID
                   And:(NSString *)birthday
                   And:(NSString *)sex
                   And:(NSString *)address
                   And:(NSString *)buildingType
                   And:(NSString *)deviceID
                   And:(NSString *)deviceType
                   And:(NSString *)pushFlg
                   And:(NSString *)rankID
              Finished:(void (^)(BOOL, int, NSString *, DesiResualt *))block
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
    NSString *content = [NSString stringWithFormat:@"&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@&%@=%@",
                         PostKey1, userID,
                         PostKey2, birthday,
                         PostKey3, sex,
                         PostKey4, [Common URLEncodedString:address],
                         PostKey5, [Common URLEncodedString:buildingType],
                         PostKey6, [Common URLEncodedString:deviceID],
                         PostKey7, deviceType,
                         PostKey8, pushFlg,
                         PostKey9, [Common URLEncodedString:rankID]];
    ASIFormDataRequest *request = [self getRequestWith:URL
                                               Modular:ModularKey
                                             Operation:ClassifyKey
                                           PostContent:content
                                                  Post:@{PostKey1: userID,
                                                         PostKey2: birthday,
                                                         PostKey3: sex,
                                                         PostKey4: address,
                                                         PostKey5: buildingType,
                                                         PostKey6: deviceID,
                                                         PostKey7: deviceType,
                                                         PostKey8: pushFlg,
                                                         PostKey9: rankID}];
    [request setDidFinishSelector:@selector(updateUserInfoFinished:)];
    [request setDidFailSelector:@selector(updateUserInfoFailed:)];
    [request setUserInfo:@{@"block":block}];
    [self startAsynchronousWith:request];
}

- (void)updateUserInfoFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dest = [self parserJSON:[request responseString]][ReturnResualt];
    void (^block)(BOOL, int, NSString *, DesiResualt *);
    int errCode = [dest[ReturnCode] intValue];
    NSString *msg = nil;
    DesiResualt *resualt = nil;
    if (errCode == 0) {
        resualt = [DesiResualt designationWith:dest[ReturnList]];
    } else {
        msg = dest[ReturnMsg];
    }
    block = request.userInfo[@"block"];
    block(YES, errCode, msg, resualt);
    
}

- (void)updateUserInfoFailed:(ASIHTTPRequest *)request
{
    void (^block)(BOOL, int, NSString *, DesiResualt *);
    block = request.userInfo[@"block"];
    block(NO, 0, nil, nil);
}
@end
