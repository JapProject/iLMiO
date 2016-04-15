

#import <UIKit/UIKit.h>
#import "AutoDownLoadImageView.h"

@interface BrandListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet AutoDownLoadImageView *brandLogo;
@property (weak, nonatomic) IBOutlet UILabel *brandName;
@property (weak, nonatomic) IBOutlet UILabel *brandNote;
@property (weak, nonatomic) IBOutlet UILabel *brandDesc;
@property (weak, nonatomic) IBOutlet UILabel *brandRate;

@end
