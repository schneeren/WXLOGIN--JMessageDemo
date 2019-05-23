//
//  ChatRoomManager.h
//  WXLogin
//
//  Created by RenShen on 2019/5/22.
//  Copyright © 2019 RenShen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChatMessageModel;
@class JMSGConversation;
#import "IMMessageManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomManager : NSObject

@property (nonatomic, strong)NSString *roomName;

@property (nonatomic, strong)IMMessageManager *sendManager;

-(instancetype)initWithJMSGConversation:(JMSGConversation *)conversation Complete:(void(^)(BOOL success))complete;
//获取所有聊天信息
-(void)getAllMessage:(void(^)(NSMutableArray <ChatMessageModel *>*messageArray))complete;

//清空未读信息
-(void)cleatUnReadCount;
//获取更多聊天信息
-(void)getMoreMessageWithIndex:(NSInteger )index Complete:(void (^)(NSArray<ChatMessageModel *> *newMessagArray ))complete;


@end

NS_ASSUME_NONNULL_END
