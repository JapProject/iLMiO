

#import "HttpManager+ShopDetail.h"
#define ModularKey         @"shop"
#define ClassifyKey        @"shop_info"

#define PostKey1        @"shop_id"

#define ReturnResualt   @"result"
#define ReturnCode      @"error"
#define ReturnList      @"list"
@implementation HttpManager (ShopDetail)
- (void)shopDetail:(NSString *)shopID Finiehed:(void (^)(BOOL, int, ShopDetail *))block
{
#if HttpTest
//    shopID = @"2";
#endif
    NSString *content = [NSString stringWithFormat:@"&%@=%@",
                         PostKey1, shopID];
    ASIFormDataRequest *request = [self getRequestWith:URL
                                               Modular:ModularKey
                                             Operation:ClassifyKey
                                           PostContent:content
                                                  Post:@{PostKey1 : shopID}];
    [request setDidFinishSelector:@selector(shopDetailFinished:)];
    [request setDidFailSelector:@selector(shopDetailFailed:)];
    [request setUserInfo:@{@"block":block}];
    [self startAsynchronousWith:request];
}

- (void)shopDetailFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dest = [self parserJSON:[request responseString]][ReturnResualt];
    void (^block)(BOOL, int, ShopDetail *);
    block = request.userInfo[@"block"];
    block(YES, [dest[ReturnCode] intValue], [ShopDetail shopDetailWiht:dest[ReturnList]]);
}

- (void)shopDetailFailed:(ASIHTTPRequest *)request
{
    void (^block)(BOOL, int, ShopDetail *);
    block = request.userInfo[@"block"];
    block(NO, 0, nil);
}

@end
