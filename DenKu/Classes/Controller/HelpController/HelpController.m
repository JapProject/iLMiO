

#import "HelpController.h"

@interface HelpController ()
@property (weak, nonatomic) IBOutlet UIScrollView *guideScrollView;

@end

@implementation HelpController
- (IBAction)clickBackBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    float width = CGRectGetWidth(self.guideScrollView.frame);

    self.guideScrollView.contentSize = CGSizeMake(width * 3, CGRectGetHeight(self.guideScrollView.frame));
    for (int i = 0; i < 3; i++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(width * i, 0, width, CGRectGetHeight(self.guideScrollView.frame))];
        img.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_%d", i]];
        [self.guideScrollView addSubview:img];
    }
    self.guideScrollView.contentInset = (UIEdgeInsets){0,0,0,0};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
