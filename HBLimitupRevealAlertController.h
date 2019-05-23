//
//  HBLimitupRevealAlertController.h
//  HBStockWarning
//
//  Created by RenShen on 2019/5/8.
//  Copyright © 2019 Touker. All rights reserved.
//

#import "HBStockBaseAlertController.h"
@class HBQuoteInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface HBLimitupRevealAlertController : HBStockBaseAlertController

@property (nonatomic, copy) void(^closeLimitupRevealAlertViewCompletionHandler)();
@property (nonatomic, copy) void (^checkMoreLimitupReveal)();

+ (instancetype)createHBLimitupRevealAlertControllerWithModle:(HBQuoteInfoModel *)stockModel;
- (void)showHBLimitupRevealAlertController:(UIViewController *)target;
@end

NS_ASSUME_NONNULL_END
