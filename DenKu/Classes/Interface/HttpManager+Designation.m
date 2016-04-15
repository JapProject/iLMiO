//


#import "HttpManager+Designation.h"

#define ModularKey         @"users"
#define ClassifyKey        @"check_user_rank"

#define PostKey1        @"rank_id"

#define ReturnResualt   @"result"
#define ReturnCode      @"error"
#define ReturnMsg       @"msg"
#define ReturnList      @"list"

@implementation HttpManager (Designation)
- (void)designation:(NSString *)ranKId Finished:(void (^)(BOOL, int, NSString *, DesiResualt *))block
{
#if HttpTest
    ranKId = @"デフォルトユーザーグループ";
#endif
    NSString *content = [NSString stringWithFormat:@"&%@=%@",
                         PostKey1, [Common URLEncodedString:ranKId]];
    ASIFormDataRequest *request = [self getRequestWith:URL
                                               Modular:ModularKey
                                             Operation:ClassifyKey
                                           PostContent:content
                                                  Post:@{PostKey1 : ranKId}];
    [request setDidFinishSelector:@selector(designationFinished:)];
    [request setDidFailSelector:@selector(designationFailed:)];
    [request setUserInfo:@{@"block":block}];
    [self startAsynchronousWith:request];
}

- (void)designationFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dest = [self parserJSON:[request responseString]][ReturnResualt];
    void (^block)(BOOL, int, NSString *, DesiResualt *);
    int errCode = [dest[ReturnCode] intValue];
    NSString *msg = nil;
    DesiResualt *resualt = nil;
    if (errCode == 0) {
        msg = dest[ReturnList][ReturnMsg];
        resualt = [DesiResualt designationWith:dest[ReturnList]];
    } else {
        msg = dest[ReturnMsg];
    }
    block = request.userInfo[@"block"];
    block(YES, errCode, msg, resualt);
}

- (void)designationFailed:(ASIHTTPRequest *)request
{
    void (^block)(BOOL, int, NSString *, DesiResualt *);
    block = request.userInfo[@"block"];
    block(NO, 0, nil, nil);
}
@end
