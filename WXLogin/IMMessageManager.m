//
//  ChatRoomMessageManager.m
//  WXLogin
//
//  Created by RenShen on 2019/5/23.
//  Copyright © 2019 RenShen. All rights reserved.
//

#import "IMMessageManager.h"
#import <JMessage/JMessage.h>
#import <YYKit.h>
#import "ChatMessageModel.h"
@interface IMMessageManager ()<JMessageDelegate>

@property (nonatomic, strong) NSMutableArray *sendMessageArray;

@end
@implementation IMMessageManager
-(instancetype)init{
    
    self = [super init];
    if (self) {
        _sendMessageArray = [NSMutableArray array];
    }
    return self;
}
-(void)setJMSG:(JMSGConversation *)JMSG{
    _JMSG = JMSG;
    [JMessage addDelegate:self withConversation:JMSG];
    
}

-(ChatMessageModel *)sendTextMessage:(NSString *)message{
    JMSGTextContent *content = [[JMSGTextContent alloc]initWithText:message];
    JMSGMessage *messageModel =  [self.JMSG createMessageWithContent:content];
    ChatMessageModel *model  = [ChatMessageModel initWithJMSGMessage:messageModel];
    model.messageStatus = isSendType;
    [_sendMessageArray addObject:model];
    [self.JMSG sendMessage:messageModel];
    return model;
}
//发送消息回调
- (void)onSendMessageResponse:(JMSGMessage *)message error:(NSError *)error{
    
    if ([message isKindOfClass:[ChatMessageModel class]]) {
         ChatMessageModel *model = (ChatMessageModel*)message;
        if (error) {
           
            model.messageStatus = haveSendFailedType;
        }else{
            model.messageStatus = haveSendSuccessedType;
        }
    }
}
//接收消息回调
-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
    
    if (!error) {
        ChatMessageModel *model = [ChatMessageModel initWithJMSGMessage:message];
        if (model&&self.receiveMessage) {
            self.receiveMessage(model);
        }
        
    }
    
}
@end
