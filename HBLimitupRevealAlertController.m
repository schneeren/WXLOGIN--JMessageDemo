//
//  HBLimitupRevealAlertController.m
//  HBStockWarning
//
//  Created by RenShen on 2019/5/8.
//  Copyright © 2019 Touker. All rights reserved.
//

#import "HBLimitupRevealAlertController.h"
#import "HBQuoteInfoModel.h"

@interface HBLimitupRevealAlertView : UIView

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@property (nonatomic, weak) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UIView *contentBGView;

@property (nonatomic, weak) IBOutlet UITextView *messageTextView;


@property (nonatomic, copy) void (^closerAlertView)();
@property (nonatomic, copy) void (^checkMoreLimitupReveal)();
@end

@implementation HBLimitupRevealAlertView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 5.0f;
    self.contentBGView.layer.borderWidth = 0.5;
    self.contentBGView.layer.borderColor = [UIColor colorWithHexString:@"#E9E9E9"].CGColor;
    
    CGFloat padding = _messageTextView.textContainer.lineFragmentPadding;
    _messageTextView.textContainerInset = UIEdgeInsetsMake(0, -padding, 0, -padding);
}
- (IBAction)checkMore:(id)sender {
    if (self.checkMoreLimitupReveal) {
        self.checkMoreLimitupReveal();
    }
}
-(IBAction)closerAlertView:(id)sender{
    
    if (self.closerAlertView) {
        self.closerAlertView();
    }
}

@end
@interface HBLimitupRevealAlertController ()
@property (strong, nonatomic) IBOutlet HBLimitupRevealAlertView *limitupRevealAlertView;
@property (nonatomic, strong) HBQuoteInfoModel *stockModel;
@end

@implementation HBLimitupRevealAlertController
+ (instancetype)createHBLimitupRevealAlertControllerWithModle:(HBQuoteInfoModel *)stockModel {
    HBLimitupRevealAlertController *LimitupRevealAlertController = [HBLimitupRevealAlertController createFromStoryboardWithStoryboardName:@"HBLimitupRevealAlertController"];
    LimitupRevealAlertController.stockModel = stockModel;
    return LimitupRevealAlertController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showlimitupRevealAlertView];
}
- (void)configUI {
    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.hb_navBarStatus = kNavBarWhiteState;
    
    NSString *messageText = StrNoNull(self.stockModel.limitUpRevealModel.limitUpReason);
    
    self.limitupRevealAlertView.messageTextView.text = messageText;
    self.limitupRevealAlertView.nameLabel.text = StrNoNull(self.stockModel.limitUpRevealModel.plateName);
    self.limitupRevealAlertView.numberLabel.text = StrNoNull(self.stockModel.limitUpRevealModel.limitUpStockNum);
    CGFloat  messageH  = [messageText boundingRectWithSize:CGSizeMake(self.limitupRevealAlertView.bounds.size.width-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    messageH = messageH >88?messageH:88;
    
    
    CGFloat limitupRevealAlertViewH =  237+messageH-88;
    
    CGFloat maxH  = ISIPHONE3_5?350:450;
    
    limitupRevealAlertViewH = limitupRevealAlertViewH>maxH?maxH:limitupRevealAlertViewH;
    
    self.limitupRevealAlertView.alpha = 0.0f;
    self.limitupRevealAlertView.frame = CGRectMake(0, 0, KScreenWidth - 30, limitupRevealAlertViewH);
    self.limitupRevealAlertView.center = CGPointMake(KScreenWidth/2.0, KScreenHeight/2.0);
    WEAK_SELF;
    self.limitupRevealAlertView.closerAlertView = ^{
         STRONG_SELF;
        [self closeSubViewAnimationCompletion:^{
            
        }];
    };
    
    self.limitupRevealAlertView.checkMoreLimitupReveal = ^{
        STRONG_SELF;
        [self  closeSubViewAnimationCompletion:^{
            if (self.checkMoreLimitupReveal) {
                self.checkMoreLimitupReveal();
            }
        }];
    };
    [self.view addSubview:self.limitupRevealAlertView];
}

- (void)showlimitupRevealAlertView {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.layer.backgroundColor = RGBA_COLOR(0, 0, 0, 0.5).CGColor;
    } completion:^(BOOL finished) {
        self.limitupRevealAlertView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.limitupRevealAlertView.alpha = 1.0f;
            self.limitupRevealAlertView.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)closeSubViewAnimationCompletion:(void (^ __nullable)(void))completion {
    [UIView animateWithDuration:0.25 animations:^{
        for (UIView *subView in self.view.subviews) {
            subView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            subView.alpha = 0;
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.25 animations:^{
            self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:YES completion:completion];
        }];
    
    }];
}
- (IBAction)cloeseLimitupRevealAlertView:(id)sender {
    
    [self closeSubViewAnimationCompletion:^{
        
    }];
}

- (void)showHBLimitupRevealAlertController:(UIViewController *)target{
    
        HBBaseNavigationController *navC = [[HBBaseNavigationController alloc] initWithRootViewController:self];
        navC.transitionDelegate = [[HBTransitionDelegate alloc] init];
        [navC.transitionDelegate setTransitionClass:[HBModalNormalAnimation new] interactionClass:nil];
        [target presentViewController:navC animated:YES completion:nil];

}
-(void)dealloc{
    NSLog(@"销毁");
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
