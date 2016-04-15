

#import "HttpManager+RefreshUserInfo.h"

#define ModularKey         @"users"
#define ClassifyKey        @"get_login_code"

#define PostKey1        @"id"

#define ReturnResualt   @"result"
#define ReturnCode      @"error"
#define ReturnMsg       @"msg"
#define ReturnList      @"list"

@implementation HttpManager (RefreshUserInfo)
- (void)refreshUserInfo:(NSString *)projectID
               Finished:(void (^)(BOOL resualt, int errorCode, NSString *msg, DesiResualt *result))block
{
    NSString *content = [NSString stringWithFormat:@"&%@=%@",
                         PostKey1, [Common URLEncodedString:[NSString stringWithFormat:@"%@",projectID]]];
    ASIFormDataRequest *request = [self getRequestWith:URL
                                               Modular:ModularKey
                                             Operation:ClassifyKey
                                           PostContent:content
                                                  Post:@{PostKey1 : projectID}];
    [request setDidFinishSelector:@selector(refreshUserInfoFinished:)];
    [request setDidFailSelector:@selector(refreshUserInfoFailed:)];
    [request setUserInfo:@{@"block":block}];
    [self startAsynchronousWith:request];
}

- (void)refreshUserInfoFinished:(ASIHTTPRequest *)request
{
    NSDictionary *dest = [self parserJSON:[request responseString]][ReturnResualt];
    void (^block)(BOOL, int, NSString *, DesiResualt *);
    int errCode = [dest[ReturnCode] intValue];
    NSString *msg = nil;
    DesiResualt *resualt = nil;
    if (errCode == 0) {
        resualt = [DesiResualt designationWith:dest[ReturnList]];
    } else {
        msg = dest[ReturnMsg];
    }
    block = request.userInfo[@"block"];
    block(YES, errCode, msg, resualt);
}

- (void)refreshUserInfoFailed:(ASIHTTPRequest *)request
{
    void (^block)(BOOL, int, NSString *, DesiResualt *);
    block = request.userInfo[@"block"];
    block(NO, 0, nil, nil);
}
@end
