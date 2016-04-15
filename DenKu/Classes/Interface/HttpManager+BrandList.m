

#import "HttpManager+BrandList.h"

#define ModularKey         @"brand"
#define ClassifyKey        @"brand_list"

#define PostKey1        @"cat_id"
#define PostKey2        @"rank_id"

#define ReturnResualt   @"result"
#define ReturnCode      @"error"
#define ReturnList      @"list"

@implementation HttpManager (BrandList)
- (void)brandList:(NSString *)classifyId And:(NSString *)rankID Finiehed:(void (^)(BOOL, int, NSArray *))block
{
#if HttpTest
//    classifyId = @"2";
#endif
    NSString *content = [NSString stringWithFormat:@"&%@=%@&%@=%@",
                         PostKey1, classifyId,
                         PostKey2, rankID];
    ASIFormDataRequest *request = [self getRequestWith:URL
                                               Modular:ModularKey
                                             Operation:ClassifyKey
                                           PostContent:content
                                                  Post:@{PostKey1 : classifyId,
                                                         PostKey2 : rankID}];
    [request setDidFinishSelector:@selector(brandListFinished:)];
    [request setDidFailSelector:@selector(brandListFailed:)];
    [request setUserInfo:@{@"block":block}];
    [self startAsynchronousWith:request];
}

- (void)brandListFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dest = [self parserJSON:[request responseString]][ReturnResualt];
    void (^block)(BOOL, int, NSArray *);
    block = request.userInfo[@"block"];
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:6];
    for (NSDictionary *dic in dest[ReturnList]) {
        [list addObject:[BrandDetail brandDetailWiht:dic]];
    }
    [list sortUsingComparator:^(BrandDetail *obj1, BrandDetail *obj2){
        return [obj1.sortOrder compare:obj2.sortOrder];
    }];
    block(YES, [dest[ReturnCode] intValue], list);
}

- (void)brandListFailed:(ASIHTTPRequest *)request
{
    void (^block)(BOOL, int, NSArray *);
    block = request.userInfo[@"block"];
    block(NO, 0, nil);

}
@end
