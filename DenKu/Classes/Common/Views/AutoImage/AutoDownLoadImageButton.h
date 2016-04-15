

#import <UIKit/UIKit.h>

@interface AutoDownLoadImageButton : UIButton
@property (nonatomic, retain) id param;
- (id)initWithURL:(NSURL *)url Json:(NSDictionary *)json Force:(BOOL)isForce SavePath:(NSString *)path Default:(NSString *)defaultName;
- (void)setImageWith:(NSURL *)url Json:(NSDictionary *)json Force:(BOOL)isForce SavePath:(NSString *)path Default:(NSString *)defaultName;

@end
