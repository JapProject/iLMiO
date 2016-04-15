

#import "HttpManager+BrandDetail.h"

#define ModularKey         @"brand"
#define ClassifyKey        @"brand_info"

#define PostKey1        @"brand_id"
#define PostKey2        @"rank_id"

#define ReturnResualt   @"result"
#define ReturnCode      @"error"
#define ReturnList      @"list"

@implementation HttpManager (BrandDetail)
- (void)brandDetail:(NSString *)brandId And:(NSString *)rankID Finiehed:(void (^)(BOOL, int, BrandDetail *))block
{
#if HttpTest
//    brandId = @"2";
#endif
    NSString *content = [NSString stringWithFormat:@"&%@=%@&%@=%@",
                         PostKey1, brandId,
                         PostKey2, rankID];
    ASIFormDataRequest *request = [self getRequestWith:URL
                                               Modular:ModularKey
                                             Operation:ClassifyKey
                                           PostContent:content
                                                  Post:@{PostKey1 : brandId,
                                                         PostKey2 : rankID}];
    [request setDidFinishSelector:@selector(brandDetailFinished:)];
    [request setDidFailSelector:@selector(brandDetailFailed:)];
    [request setUserInfo:@{@"block":block}];
    [self startAsynchronousWith:request];
}

- (void)brandDetailFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dest = [self parserJSON:[request responseString]][ReturnResualt];
    void (^block)(BOOL, int, BrandDetail *);
    block = request.userInfo[@"block"];
    block(YES, [dest[ReturnCode] intValue], [BrandDetail brandDetailWiht:dest[ReturnList]]);
}

- (void)brandDetailFailed:(ASIHTTPRequest *)request
{
    void (^block)(BOOL, int, BrandDetail *);
    block = request.userInfo[@"block"];
    block(NO, 0, nil);
}
@end
