

#import "NHViewController.h"
#import "BLRView.h"
@class QRResualt;

@protocol CheckResultControllerDelegate <NSObject>
@optional
- (void)clickBackTopPage;
- (void)willDisAppear;
@end

@interface CheckResultController : NHViewController
@property (weak, nonatomic) IBOutlet BLRView *bgVIew;
@property (nonatomic, strong) QRResualt *resault;
@property (nonatomic, weak) id<CheckResultControllerDelegate> delegate;
@end
