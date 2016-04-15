

#import "HttpManager+SearchShopWithWords.h"
#define ModularKey         @"shop"
#define ClassifyKey        @"search_shop"

#define PostKey1        @"keyword"
#define PostKey2        @"rank_id"

#define ReturnResualt   @"result"
#define ReturnCode      @"error"
#define ReturnList      @"list"
@implementation HttpManager (SearchShopWithWords)
- (void)SearchShopWithWords:(NSString *)keyWords And:(NSString *)rankID Finiehed:(void (^)(BOOL, int, NSArray *))block
{
#if HttpTest
//    keyWords = @"店舗";
#endif
    NSString *content = [NSString stringWithFormat:@"&%@=%@&%@=%@",
                         PostKey1, [Common URLEncodedString:keyWords], PostKey2, rankID];
    ASIFormDataRequest *request = [self getRequestWith:URL
                                               Modular:ModularKey
                                             Operation:ClassifyKey
                                           PostContent:content
                                                  Post:@{PostKey1 : keyWords,
                                                         PostKey2 : rankID}];
    [request setDidFinishSelector:@selector(SearchShopWithWordsFinished:)];
    [request setDidFailSelector:@selector(SearchShopWithWordsFailed:)];
    [request setUserInfo:@{@"block":block}];
    [self startAsynchronousWith:request];
}

- (void)SearchShopWithWordsFinished:(ASIHTTPRequest *)request
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

- (void)SearchShopWithWordsFailed:(ASIHTTPRequest *)request
{
    void (^block)(BOOL, int, NSArray *);
    block = request.userInfo[@"block"];
    block(NO, 0, nil);
    
}
@end
