

#import "HttpManager+NewsDetail.h"
#define ModularKey         @"news"
#define ClassifyKey        @"news_info"

#define PostKey1        @"id"

#define ReturnResualt   @"result"
#define ReturnCode      @"error"
#define ReturnList      @"list"
@implementation HttpManager (NewsDetail)
- (void)newsDetail:(NSString *)newsID Finiehed:(void (^)(BOOL, int, NewsDetail *))block
{
#if HttpTest
//    newsID = @"1";
#endif
    NSString *content = [NSString stringWithFormat:@"&%@=%@",
                         PostKey1, newsID];
    ASIFormDataRequest *request = [self getRequestWith:URL
                                               Modular:ModularKey
                                             Operation:ClassifyKey
                                           PostContent:content
                                                  Post:@{PostKey1 : newsID}];
    [request setDidFinishSelector:@selector(newsDetailFinished:)];
    [request setDidFailSelector:@selector(newsDetaillFailed:)];
    [request setUserInfo:@{@"block":block}];
    [self startAsynchronousWith:request];
}

- (void)newsDetailFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dest = [self parserJSON:[request responseString]][ReturnResualt];
    void (^block)(BOOL, int, NewsDetail *);
    block = request.userInfo[@"block"];
    block(YES, [dest[ReturnCode] intValue], [NewsDetail newsDetailWith:dest[ReturnList]]);
}

- (void)newsDetaillFailed:(ASIHTTPRequest *)request
{
    void (^block)(BOOL, int, NewsDetail *);
    block = request.userInfo[@"block"];
    block(NO, 0, nil);
}

@end
