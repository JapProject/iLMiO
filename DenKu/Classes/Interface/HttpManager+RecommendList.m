
#import "HttpManager+RecommendList.h"

#define ModularKey         @"brand"
#define ClassifyKey        @"brand_list_index"
#define HomeAllList        @"brand_list_index_all"

#define PostKey1        @"type"
#define PostKey2        @"rank_id"

#define ReturnResualt   @"result"
#define ReturnCode      @"error"
#define ReturnList      @"list"

@implementation HttpManager (RecommendList)
- (void)recommendList:(NSString *)type And:(NSString *)rankID Finished:(void (^)(BOOL, int, NSArray *))block
{
#if HttpTest
//    type = @"recommend";
#endif
    NSString * content  = [NSString stringWithFormat:@"&%@=%@&%@=%@",
                           PostKey1, type,
                           PostKey2, rankID];;
    NSString *Operation = ClassifyKey;
    NSDictionary *requsetInfo =@{PostKey1 : type,
                                 PostKey2 : rankID}; ;
    if ([rankID isEqualToString:@"-1"]) {
        Operation = HomeAllList;
    }
    ASIFormDataRequest *request = [self getRequestWith:URL
                                               Modular:ModularKey
                                             Operation:Operation
                                           PostContent:content
                                                  Post:requsetInfo];
    [request setDidFinishSelector:@selector(recommendListFinished:)];
    [request setDidFailSelector:@selector(recommendListFailed:)];
    [request setUserInfo:@{@"block":block}];
    [self startAsynchronousWith:request];
    
//    NSData *htmlData = [[NSData alloc] initWithContentsOfURL:request.url];
//    NSString *tmp = [[NSString alloc] initWithBytes:[htmlData bytes] length:[htmlData length] encoding:NSNEXTSTEPStringEncoding];

}

- (void)recommendListFinished:(ASIHTTPRequest *)request
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

- (void)recommendListFailed:(ASIHTTPRequest *)request
{
    
    void (^block)(BOOL, int, NSArray *);
    block = request.userInfo[@"block"];
    block(NO, 0, nil);
    
}
@end
