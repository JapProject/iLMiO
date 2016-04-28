

#import "HttpManager+ShopListWithMap.h"
#define ModularKey         @"shop"
#define ClassifyKey        @"nearby_shop"

#define PostKey1        @"longitude"
#define PostKey2        @"latitude"
#define PostKey3        @"rank_id"

#define ReturnResualt   @"result"
#define ReturnCode      @"error"
#define ReturnList      @"list"
@implementation HttpManager (ShopListWithMap)
- (void)shopListWith:(NSString *)longitude And:(NSString *)latitude And:(NSString *)rankID Finished:(void (^)(BOOL, int, NSArray *))block
{
#if HttpTest
//    longitude = @"116.418893";
//    latitude = @"40.059332";
#endif
    if (!rankID) {
        rankID = @"";
    }
    NSString *content = [NSString stringWithFormat:@"&%@=%@&%@=%@&%@=%@",
                         PostKey1, longitude, PostKey2, latitude, PostKey3, rankID];
    ASIFormDataRequest *request = [self getRequestWith:URL
                                               Modular:ModularKey
                                             Operation:ClassifyKey
                                           PostContent:content
                                                  Post:@{PostKey1 : longitude,
                                                         PostKey2 : latitude,
                                                         PostKey3 : rankID}];
    [request setDidFinishSelector:@selector(shopListWithFinished:)];
    [request setDidFailSelector:@selector(shopListWithFailed:)];
    [request setUserInfo:@{@"block":block}];
    [self startAsynchronousWith:request];
}

- (void)shopListWithFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dest = [self parserJSON:[request responseString]][ReturnResualt];
    void (^block)(BOOL, int, NSArray *);
    block = request.userInfo[@"block"];
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:6];
    for (NSDictionary *dic in dest[ReturnList]) {
        [list addObject:[ShopDetail shopDetailWiht:dic]];
    }
    block(YES, [dest[ReturnCode] intValue], list);
}

- (void)shopListWithFailed:(ASIHTTPRequest *)request
{
    void (^block)(BOOL, int, NSArray *);
    block = request.userInfo[@"block"];
    block(NO, 0, nil);
    
}
@end
