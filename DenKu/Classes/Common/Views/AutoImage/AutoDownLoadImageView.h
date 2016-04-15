

#import <UIKit/UIKit.h>

@interface AutoDownLoadImageView : UIImageView
@property (nonatomic, assign) BOOL isClipCircle;
@property (nonatomic, copy) void (^finishedBlock)(UIImage *image);

- (id)initWithURL:(NSURL *)url Json:(NSDictionary *)json Force:(BOOL)isForce SavePath:(NSString *)path Default:(NSString *)defaultName;
- (void)setImageWith:(NSURL *)url Json:(NSDictionary *)json Force:(BOOL)isForce SavePath:(NSString *)path Default:(NSString *)defaultName;
- (void)setImageWith:(NSURL *)url Json:(NSDictionary *)json Force:(BOOL)isForce SavePath:(NSString *)path Default:(NSString *)defaultName isClipCircle:(BOOL)isCircle;

@end
