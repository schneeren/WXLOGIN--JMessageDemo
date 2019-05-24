//
//  ListVC.h
//  WXLogin
//
//  Created by RenShen on 2019/5/24.
//  Copyright © 2019 RenShen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JMSGConversation;
NS_ASSUME_NONNULL_BEGIN

@interface ListVC : UIViewController

@property (nonatomic, strong)NSMutableArray <JMSGConversation *>*listArray;

@property (nonatomic)NSInteger chatType;

-(void)reloadList;

@end

NS_ASSUME_NONNULL_END
