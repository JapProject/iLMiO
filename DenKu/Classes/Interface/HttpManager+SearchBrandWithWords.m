

#import "HttpManager+SearchBrandWithWords.h"
#define ModularKey         @"brand"
#define ClassifyKey        @"search_brand_list"

#define PostKey1        @"type"
#define PostKey2        @"rank_id"

#define ReturnResualt   @"result"
#define ReturnCode      @"error"
#define ReturnMsg       @"msg"
#define ReturnList      @"list"
@implementation HttpManager (SearchBrandWithWords)
- (void)SearchBrandWithWords:(NSString *)keyWords And:(NSString *)rankID Finiehed:(void (^)(BOOL, int, NSString *msg, NSArray *))block
{
    keyWords = @"recommend";
    NSString *content = [NSString stringWithFormat:@"&%@=%@&%@=%@",
                         PostKey1, [Common URLEncodedString:keyWords],
                         PostKey2, rankID];
    ASIFormDataRequest *request = [self getRequestWith:URL
                                               Modular:ModularKey
                                             Operation:ClassifyKey
                                           PostContent:content
                                                  Post:@{PostKey1 : keyWords,
                                                         PostKey2 : rankID}];
    [request setDidFinishSelector:@selector(SearchBrandWithWordsFinished:)];
    [request setDidFailSelector:@selector(SearchBrandWithWordsFailed:)];
    [request setUserInfo:@{@"block":block}];
    [self startAsynchronousWith:request];
}

- (void)SearchBrandWithWordsFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dest = [self parserJSON:[request responseString]][ReturnResualt];
    void (^block)(BOOL, int, NSString *msg, NSArray *);
    block = request.userInfo[@"block"];
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:6];
    for (NSDictionary *dic in dest[ReturnList]) {
        [list addObject:[BrandDetail brandDetailWiht:dic]];
    }
//    [list sortUsingComparator:^(BrandDetail *obj1, BrandDetail *obj2){
//        return [obj1.brandName compare:obj2.brandName];
//    }];
    block(YES, [dest[ReturnCode] intValue], dest[ReturnMsg], list);
}

- (void)SearchBrandWithWordsFailed:(ASIHTTPRequest *)request
{
    void (^block)(BOOL, int, NSString *msg, NSArray *);
    block = request.userInfo[@"block"];
    block(NO, 0, nil, nil);
    
}

@end
