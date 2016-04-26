

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "DataModal.h"

@protocol HttpManagerDelegate <NSObject>


@end

@interface HttpManager : NSObject

@property (nonatomic, weak) id<HttpManagerDelegate> delegate;

+ (HttpManager *)shareHttpManager;

- (void)startAsynchronousWith:(ASIHTTPRequest *)request;
- (ASIFormDataRequest *)getRequestWith:(NSString *)url
                               Modular:(NSString *)modular
                             Operation:(NSString *)classify
                           PostContent:(NSString *)content
                                  Post:(NSDictionary *)wsParas;

- (ASIFormDataRequest *)getASISOAP11Request:(NSString *) WebURL
                                  InterFace:(NSString *)funcName
                                 Parameters:(NSArray *) wsParas;
- (NSDictionary *)parserXML:(NSString *)content;
- (id)parserJSON:(NSString *)content;
- (NSString *)parserReturn:(NSDictionary *)diction;

@end

@interface HttpManager ()

@end

#define URL                 @"http://153.121.37.86/index.php?"  //测试
//#define URL                 @"http://www1099gk.sakura.ne.jp/index.php?" //正式
#define SecretKey           @"thisisajapanesekey"

#define HttpTest    0