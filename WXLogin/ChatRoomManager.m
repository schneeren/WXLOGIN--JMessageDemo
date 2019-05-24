//
//  ChatRoomManager.m
//  WXLogin
//
//  Created by RenShen on 2019/5/22.
//  Copyright © 2019 RenShen. All rights reserved.
//

#import "ChatRoomManager.h"
#import <JMessage/JMessage.h>
#import <YYKit.h>
#import "ChatMessageModel.h"

@interface ChatRoomManager()<JMessageDelegate>

@property (nonatomic, strong) JMSGConversation *JMSG;

@property (nonatomic) BOOL creatRoomYES;

@end;

@implementation ChatRoomManager


-(instancetype)initWithJMSGConversation:(JMSGConversation *)conversation Complete:(void (^)(BOOL))complete{
    
    if (self = [super init]) {
    self.sendManager = [[IMMessageManager alloc]init];
    JMSGConversationType type= conversation.conversationType;
    switch (type) {
        case 1:{
            //单独会话
            JMSGUser *user = (JMSGUser *)conversation.target;
           
            [JMSGConversation createSingleConversationWithUsername:user.username completionHandler:^(id resultObject, NSError *error) {
                NSLog(@"单聊resultObject--%@",resultObject);
                if (error) {
                    self.creatRoomYES = NO;
                    complete(NO);
                    return ;
                }
                JMSGConversation *JMSG =(JMSGConversation *)resultObject;
                
                self.JMSG = JMSG;
                if (resultObject) {
                    self.creatRoomYES = YES;
                    self.sendManager.JMSG = JMSG;
                    complete(YES);
                }
            }];
        }
            break;
        case 2:{
            //群组
            JMSGGroup *group = (JMSGGroup *)conversation.target;
            [JMSGConversation createGroupConversationWithGroupId:group.gid completionHandler:^(id resultObject, NSError *error) {
                NSLog(@"群组resultObject--%@",resultObject);
                if (error) {
                    self.creatRoomYES = NO;
                    complete(NO);
                    return ;
                }
                JMSGConversation *JMSG =(JMSGConversation *)resultObject;
                
                self.JMSG = JMSG;
                if (resultObject) {
                    self.creatRoomYES = YES;
                    self.sendManager.JMSG = JMSG;
                    complete(YES);
                }
            }];
            
        }
            break;
        case 3:{
            //聊天室
            
        }
        default:
            break;
    }
        
    }
    return self;
}

-(void)getAllMessage:(void (^)(NSMutableArray <ChatMessageModel*>* _Nonnull))complete{
    
    [self.JMSG allMessages:^(id resultObject, NSError *error) {
        NSMutableArray *messageArray = [NSMutableArray array];
        if (!error) {
            resultObject = (NSArray *)resultObject;
        
            
            [resultObject enumerateObjectsUsingBlock:^(JMSGMessage*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (obj.contentType <4) {
                    ChatMessageModel *messageModel =[self getChatMessageModel:obj];
                    [messageArray addObject:messageModel];
                }
            }];
        }
//        self.messageArray = messageArray;
        complete(messageArray);

    }];
}
-(void)cleatUnReadCount{
    [self.JMSG clearUnreadCount];
}
-(void)getMoreMessageWithIndex:(NSInteger )index Complete:(void (^)(NSArray<ChatMessageModel *> * _Nonnull))complete{
    NSNumber *offset = [NSNumber numberWithInteger:index];//从第几条信息开始
    NSNumber *limt = [NSNumber numberWithInteger:20];
    //消息翻转过来
    NSArray *array =  [[[self.JMSG messageArrayFromNewestWithOffset:offset limit:limt] reverseObjectEnumerator]allObjects];
    
    NSMutableArray *newMessageArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(JMSGMessage *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.contentType <4) {
            ChatMessageModel *messageModel =[self getChatMessageModel:obj];
            [newMessageArray addObject:messageModel];
        }

    }];
    
//    if (newMessageArray.count == 0&&offset == 0) {
//        //当刚开始请求不到数据时候s，说明本地无数据，从服务器拉取下
//        [self getAllMessage:^(NSMutableArray<ChatMessageModel *> * _Nonnull messageArray) {
//            if (messageArray.count>0) {
//
//                    complete(messageArray);
//
//            }
//        }];
//    }else{
        complete(newMessageArray);
//    }
}
-(ChatMessageModel *)getChatMessageModel:(id )obj{
    JMSGMessage *messageModel = (JMSGMessage *)obj;

    ChatMessageModel *chatMessageModel =[ChatMessageModel initWithJMSGMessage:messageModel];
    
    return chatMessageModel;
}

-(NSString *)roomName{
    NSString *titile = self.JMSG.title;
    if (titile.length == 0&&self.JMSG.conversationType ==kJMSGConversationTypeGroup ) {
        JMSGGroup *group = (JMSGGroup *)self.JMSG.target;
        titile = group.displayName;
    }
    return self.JMSG.title;
}
@end
