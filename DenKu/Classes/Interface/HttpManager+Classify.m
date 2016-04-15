
#import "HttpManager+Classify.h"

#define ModularKey         @"category"
#define ClassifyKey        @"cat_list"

#define ReturnResualt   @"result"
#define ReturnCode      @"error"
#define ReturnList      @"list"

@implementation HttpManager (Classify)

- (void)classifyList:(void (^)(BOOL, int, NSArray *))block
{
    ASIFormDataRequest *request = [self getRequestWith:URL
                                               Modular:ModularKey
                                             Operation:ClassifyKey
                                           PostContent:nil
                                                  Post:nil];
    [request setDidFinishSelector:@selector(classifyFinished:)];
    [request setDidFailSelector:@selector(classifyFailed:)];
    [request setUserInfo:@{@"block":block}];
    [self startAsynchronousWith:request];
}

- (void)classifyFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dest = [self parserJSON:[request responseString]][ReturnResualt];
    void (^block)(BOOL, int, NSArray *);
    block = request.userInfo[@"block"];
    NSMutableArray *list = [NSMutableArray arrayWithCapacity:6];
    for (NSDictionary *dic in dest[ReturnList]) {
        [list addObject:[ClassifyDetail classifyDetailWith:dic]];
    }
    block(YES, [dest[ReturnCode] intValue], list);
}

- (void)classifyFailed:(ASIHTTPRequest *)request
{
    void (^block)(BOOL, int, NSArray *);
    block = request.userInfo[@"block"];
    block(NO, 0, nil);
}
@end
