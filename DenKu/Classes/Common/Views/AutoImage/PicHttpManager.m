

#import "PicHttpManager.h"
#import "JsonStringConstructor.h"
#import "SBJsonWriter.h"

#define kHttpDownloadPicTimeOut     60

@interface PicHttpManager ()
@property (nonatomic, retain) NSCache *imgCache;
@property (nonatomic, retain) NSMutableDictionary *requestDic;
@end

@implementation PicHttpManager
SYNTHESIZE_SINGLETON_FOR_CLASS(PicHttpManager);

- (id)init
{
    if (self = [super init]) {
        self.imgCache = [[[NSCache alloc] init] autorelease];
        self.requestDic = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return self;
}

- (void)dealloc
{
    self.imgCache = nil;
    [super dealloc];
}

- (void)httpForPic:(NSString *)savePath DownURL:(NSURL *)url Json:(NSDictionary *) json
{
    if (!url) {
        return;
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

    if (json) {
        SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
        NSString *jsonStr = [jsonWriter stringWithObject:json];
        [request addPostValue:jsonStr forKey:@"json"];
        [jsonWriter release];
    }
    [request setRequestMethod:@"GET"];
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setTimeOutSeconds:kHttpDownloadPicTimeOut];//设置超时间
    [request setDownloadDestinationPath:savePath];
    [request setDelegate:self];
    [request startAsynchronous];
    [self.requestDic setObject:request forKey:[url absoluteString]];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    [[NSNotificationCenter defaultCenter] postNotificationName:request.downloadDestinationPath object:self];
    [self.requestDic removeObjectForKey:[request.url absoluteString]];
    NSLog(@"auto download image description:\n%@\nURL:%@\nsave path:%@",
          [request responseStatusMessage], request.url, request.downloadDestinationPath);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [self.requestDic removeObjectForKey:[request.url absoluteString]];
}

- (void)cancelDownloadImageWith:(NSString *)absoluteURL
{
    if (absoluteURL) {
        ASIFormDataRequest *request = self.requestDic[absoluteURL];
        if (request) {
            [request cancel];
            [self.requestDic removeObjectForKey:[request.url absoluteString]];
        }
    }
}

- (void)setImage:(UIImage *)image With:(id)key
{
    if (!image) {
        return;
    }
    [self.imgCache setObject:image forKey:key];
}

- (UIImage *)imageWith:(id)key
{
    return [self.imgCache objectForKey:key];
}

- (UIImage *)imageWithName:(NSString *)name
{
    UIImage *img = [self imageWith:name];
    if (!img) {
        img = [UIImage imageNamed:name];
        [self setImage:img With:name];
    }
    return img;
}

- (UIImage *)imageWithPath:(NSString *)path
{
    UIImage *img = [self imageWith:path];
    if (!img) {
        img = [UIImage imageWithContentsOfFile:path];
        [self setImage:img With:path];
    }
    return img;
}

@end

void registerNotifyForPic(id obj, NSString *savePath, SEL selector)
{
    [[NSNotificationCenter defaultCenter] addObserver:obj
                                             selector:selector
                                                 name:savePath
                                               object:GET_SINGLETON_FOR_CLASS(PicHttpManager)];
}

void removeNotifyForPic(id obj, NSString *savePath)
{
    [[NSNotificationCenter defaultCenter] removeObserver:obj
                                                    name:savePath
                                                  object:GET_SINGLETON_FOR_CLASS(PicHttpManager)];
}