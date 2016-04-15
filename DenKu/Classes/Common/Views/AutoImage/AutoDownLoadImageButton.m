

#import "AutoDownLoadImageButton.h"
#import "PicHttpManager.h"

@interface AutoDownLoadImageButton ()
@property (nonatomic, retain) NSString *defaultImg;
@property (nonatomic, retain) NSURL *downURL;
@property (nonatomic, retain) NSString *savePath;
@end

@implementation AutoDownLoadImageButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithURL:(NSURL *)url Json:(NSDictionary *)json Force:(BOOL)isForce SavePath:(NSString *)path Default:(NSString *)defaultName
{
    if (self = [super init]) {
        [self setImageDownWith:url Json:json Force:isForce SavePath:path Default:defaultName];
    }
    return self;
}

- (void)dealloc
{
    removeNotifyForPic(self, self.savePath);
    self.param = nil;
    self.downURL = nil;
    self.savePath = nil;
    self.defaultImg = nil;
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setImageDownWith:(NSURL *)url
                    Json:(NSDictionary *)json
                   Force:(BOOL)isForce
                SavePath:(NSString *)path
                 Default:(NSString *)defaultName
{
    removeNotifyForPic(self, self.savePath);
    registerNotifyForPic(self, path, @selector(imageChanged));
    self.downURL = url;
    self.savePath = path;
    self.defaultImg = defaultName;
    
    PicHttpManager *manager = GET_SINGLETON_FOR_CLASS(PicHttpManager);
    UIImage *image = [manager imageWithPath:path];
    if (image) {
        [self setImage:image forState:UIControlStateNormal];
        if (isForce) {
            [manager httpForPic:path DownURL:url Json:json];
        }
    } else {
        if(![[NSFileManager defaultManager] fileExistsAtPath:path]){
            [[NSFileManager defaultManager] createDirectoryAtPath:path
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
        }
        [self setImage:[manager imageWithName:defaultName] forState:UIControlStateNormal];
        [manager httpForPic:path DownURL:url Json:json];
    }

}

- (void)setImageWith:(NSURL *)url Json:(NSDictionary *)json Force:(BOOL)isForce SavePath:(NSString *)path Default:(NSString *)defaultName
{
    if ([[self.downURL absoluteString] isEqualToString:[url absoluteString]]) {
        PicHttpManager *manager = GET_SINGLETON_FOR_CLASS(PicHttpManager);
        [manager cancelDownloadImageWith:[self.downURL absoluteString]];
    }
    [self setImageDownWith:url Json:json Force:isForce SavePath:path Default:defaultName];
}

- (void)removeFromSuperview
{
    PicHttpManager *manager = GET_SINGLETON_FOR_CLASS(PicHttpManager);
    [manager cancelDownloadImageWith:[self.downURL absoluteString]];

    [super removeFromSuperview];
}


- (void)imageChanged
{
    PicHttpManager *manager = GET_SINGLETON_FOR_CLASS(PicHttpManager);
    UIImage *image = [manager imageWithPath:self.savePath];
    if (image) {
        self.alpha = 0.1;
        [UIView animateWithDuration:0.2 animations:^{
            [self setImage:image forState:UIControlStateNormal];
            self.alpha = 1.0;
        }];
    }
}

@end
