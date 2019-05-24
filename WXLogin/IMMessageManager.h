//
//  ChatRoomMessageManager.h
//  WXLogin
//
//  Created by RenShen on 2019/5/23.
//  Copyright © 2019 RenShen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ChatMessageModel;
@class JMSGConversation;
//@protocol IMMessageManagerDelegate <NSObject>
//
//
//@end

@interface IMMessageManager : NSObject

@property (nonatomic, weak) JMSGConversation *JMSG;
//所有信息
@property (nonatomic, copy) void (^receiveMessage)(ChatMessageModel *messageModel);
//聊天
@property (nonatomic, copy) void (^receiveChatMessage)(ChatMessageModel *messageModel);
//通知
@property (nonatomic, copy) void (^receiveEventMessage)(ChatMessageModel *messageModel);

-(ChatMessageModel *)sendTextMessage:(NSString *)message;

-(ChatMessageModel *)sendImageMessage:(UIImage *)image;


@end


