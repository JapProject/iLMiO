

#import "HttpManager+ShopListWithBrandID.h"
#define ModularKey         @"brand"
#define ClassifyKey        @"brand_shop_list"

#define PostKey1        @"brand_id"

#define ReturnResualt   @"result"
#define ReturnCode      @"error"
#define ReturnList      @"list"

@implementation HttpManager (BrandListWithBrandID)
- (void)shopListWithBrand:(NSString *)brandID Finiehed:(void (^)(BOOL, int, NSArray *))block
{
#if HttpTest
//    brandID = @"2";
#endif
    NSString *content = [NSString stringWithFormat:@"&%@=%@",
                         PostKey1, brandID];
    ASIFormDataRequest *request = [self getRequestWith:URL
                                               Modular:ModularKey
                                             Operation:ClassifyKey
                                           PostContent:content
                                                  Post:@{PostKey1 : brandID}];
    [request setDidFinishSelector:@selector(shopListWithBrandFinished:)];
    [request setDidFailSelector:@selector(shopListWithBrandFailed:)];
    [request setUserInfo:@{@"block":block}];
    [self startAsynchronousWith:request];
}

- (void)shopListWithBrandFinished:(ASIHTTPRequest *)request
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

- (void)shopListWithBrandFailed:(ASIHTTPRequest *)request
{
    void (^block)(BOOL, int, NSArray *);
    block = request.userInfo[@"block"];
    block(NO, 0, nil);
    
}
@end
