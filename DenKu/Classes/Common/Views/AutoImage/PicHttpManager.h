

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface PicHttpManager : NSObject<ASIHTTPRequestDelegate>
DECLARE_SINGLETON_FOR_CLASS(PicHttpManager)
- (void)httpForPic:(NSString *)savePath DownURL:(NSURL *)url Json:(NSDictionary *) json;
- (void)cancelDownloadImageWith:(NSString *)absoluteURL;
- (UIImage *)imageWithPath:(NSString *)path;
- (UIImage *)imageWithName:(NSString *)name;

@end

void registerNotifyForPic(id obj, NSString *savePath, SEL selector);
void removeNotifyForPic(id obj, NSString *savePath);
