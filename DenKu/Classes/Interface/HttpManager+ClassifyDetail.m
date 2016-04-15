

#import "HttpManager+ClassifyDetail.h"

#define ModularKey         @"category"
#define ClassifyKey        @"cat_info"

#define PostKey1        @"cat_id"

#define ReturnResualt   @"result"
#define ReturnCode      @"error"
#define ReturnList      @"list"

@implementation HttpManager (ClassifyDetail)
- (void)classifyDetail:(NSString *)classifyId Finiehed:(void (^)(BOOL, int, NSDictionary *))block
{
#if HttpTest
//    classifyId = @"2";
#endif
    NSString *content = [NSString stringWithFormat:@"&%@=%@",
                         PostKey1, classifyId];
    ASIFormDataRequest *request = [self getRequestWith:URL
                                               Modular:ModularKey
                                             Operation:ClassifyKey
                                           PostContent:content
                                                  Post:@{PostKey1 : classifyId}];
    [request setDidFinishSelector:@selector(classifyDetailFinished:)];
    [request setDidFailSelector:@selector(classifyDetailFailed:)];
    [request setUserInfo:@{@"block":block}];
    [self startAsynchronousWith:request];

}

- (void)classifyDetailFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dest = [self parserJSON:[request responseString]][ReturnResualt];
    void (^block)(BOOL, int, NSDictionary *);
    block = request.userInfo[@"block"];
    block(YES, [dest[ReturnCode] intValue], dest[ReturnList]);
}

- (void)classifyDetailFailed:(ASIHTTPRequest *)request
{
    void (^block)(BOOL, int, NSDictionary *);
    block = request.userInfo[@"block"];
    block(NO, 0, nil);
}
@end
