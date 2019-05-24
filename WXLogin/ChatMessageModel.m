//
//  ChatRoomModel.m
//  WXLogin
//
//  Created by RenShen on 2019/5/22.
//  Copyright © 2019 RenShen. All rights reserved.
//

#import "ChatMessageModel.h"
#import <YYKit.h>

@implementation ChatMessageModel
+(instancetype)initWithJMSGMessage:(JMSGMessage *)SGMessage{
    
    object_setClass(SGMessage, [ChatMessageModel class]);
    
    ChatMessageModel *chatMessageModel =(ChatMessageModel *)SGMessage;
    
    return chatMessageModel;
    
}
-(NSString *)name{

    NSString *name = self.fromUser.noteName;
    if (name.length == 0) {
        name = self.fromUser.nickname;
    }
    return name;
    
}
-(NSString *)userName{
    
    return self.fromUser.username;
}
-(NSString *)messageText{
    
     return  ((JMSGTextContent *)self.content).text;
    
}
-(GroupEventType)groupEventType{
    
    if ((self.contentType != kJMSGContentTypeEventNotification)||(self.targetType !=kJMSGConversationTypeGroup)) {
        return 0;
    }
    JMSGEventContent *content = (JMSGEventContent *)self.content;
    /*
     // 消息事件
     /// 事件类型: 群组被创建
     kJMSGEventNotificationCreateGroup = 8,
     /// 事件类型: 退出群组
     kJMSGEventNotificationExitGroup = 9,
     /// 事件类型: 群组添加新成员
     kJMSGEventNotificationAddGroupMembers = 10,
     /// 事件类型: 群组成员被踢出
     kJMSGEventNotificationRemoveGroupMembers = 11,
     /// 事件类型: 群信息更新
     kJMSGEventNotificationUpdateGroupInfo = 12,
     /// 事件类型: 群禁言通知事件
     kJMSGEventNotificationGroupMemberSilence = 65,
     /// 事件类型: 管理员角色变更通知事件
     kJMSGEventNotificationGroupAdminChange = 80,
     /// 事件类型: 群主变更通知事件
     kJMSGEventNotificationGroupOwnerChange = 82,
     /// 事件类型: 群类型变更通知事件
     kJMSGEventNotificationGroupTypeChange = 83,
     /// 事件类型: 解散群组
     kJMSGEventNotificationDissolveGroup = 11001,
     /// 事件类型: 群组成员上限变更
     kJMSGEventNotificationGroupMaxMemberCountChange = 11002,
     */
    switch (content.eventType) {
        case 9:{
            JMSGGroup  *group = self.target;
            [JMSGConversation deleteGroupConversationWithGroupId:group.gid];
        }
            _groupEventType =GroupEventExitType;
            break;
        case 10:
            _groupEventType = GroupMembersChangeType;
            break;
        case 11:{
            JMSGGroup  *group = self.target;
             [JMSGConversation deleteGroupConversationWithGroupId:group.gid];
            _groupEventType = GoroupRemoveGroupType;
        }
            break;
        case 12:
            _groupEventType = GroupInfoChangeType;
            break;
        case 11001:{
            JMSGGroup  *group = self.target;
            [JMSGConversation deleteGroupConversationWithGroupId:group.gid];
            _groupEventType = GroupDissolveType;
        }
            break;
        default:
            _groupEventType = GroupEventUNKnowType;
            break;
    }
    return _groupEventType;
}
-(void)loadThumbnailUserHeadImage:(void (^)(NSData * _Nonnull))complete{
    
//    NSString *path = [self.fromUser thumbAvatarLocalPath];
//    if (path) {
//        NSData *data = [NSData dataWithContentsOfFile:path];
//        complete(data);
//    }else{
    
    [self.fromUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        if (data) {
//            NSString *path = [self.fromUser thumbAvatarLocalPath];
//            NSData *data = [NSData dataWithContentsOfFile:path];
            complete(data);
        }
        
    }];
//    }
}
-(void)loadLargeUserHeadImage:(void (^)(NSData * _Nonnull))complete{
    
    [self.fromUser largeAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        if (data) {
            complete(data);
        }
    }];
}
-(void)dealloc{
    
    object_setClass(self, [JMSGMessage class]);
    
}
@end
