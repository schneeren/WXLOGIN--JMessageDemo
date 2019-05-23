//
//  ChatRoomVC.h
//  WXLogin
//
//  Created by RenShen on 2019/5/22.
//  Copyright © 2019 RenShen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>
NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomVC : UIViewController


+(instancetype)creatChatRoomWithJMSGConversation:(JMSGConversation *)conversation;;

@end

NS_ASSUME_NONNULL_END
