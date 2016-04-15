
#import "HttpManager+NewsList.h"
#define ModularKey         @"news"
#define ClassifyKey        @"news_list"

#define PostKey1        @"page"

#define ReturnResualt   @"result"
#define ReturnCode      @"error"
#define ReturnList      @"list"
#define ReturnTotal     @"total_page"
#define ReturnNews      @"news_list"

@implementation HttpManager (NewsList)
- (void)newsList:(NSString *)page Finished:(void (^)(BOOL, int, NSString *, NSNumber *, NSArray *))block
{
#if HttpTest
//    page = @"1";
#endif
    NSString *content = [NSString stringWithFormat:@"&%@=%@",
                         PostKey1, page];
    ASIFormDataRequest *request = [self getRequestWith:URL
                                               Modular:ModularKey
                                             Operation:ClassifyKey
                                           PostContent:content
                                                  Post:@{PostKey1 : page}];
    [request setDidFinishSelector:@selector(newsListFinished:)];
    [request setDidFailSelector:@selector(newsListFailed:)];
    [request setUserInfo:@{@"block":block,
                           @"page":page}];
    [self startAsynchronousWith:request];
}

- (void)newsListFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dest = [self parserJSON:[request responseString]][ReturnResualt];
    void (^block)(BOOL, int, NSString *, NSNumber *, NSArray *);
    block = request.userInfo[@"block"];
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:6];
    for (NSDictionary *dic in dest[ReturnList][ReturnNews]) {
        [list addObject:[NewsDetail newsDetailWith:dic]];
    }
    block(YES, [dest[ReturnCode] intValue], request.userInfo[@"page"], dest[ReturnList][ReturnTotal], list);
}

- (void)newsListFailed:(ASIHTTPRequest *)request
{
    void (^block)(BOOL, int, NSString *, NSNumber *, NSArray *);
    block = request.userInfo[@"block"];
    block(NO, 0, request.userInfo[@"page"], 0,nil);
    
}

@end
