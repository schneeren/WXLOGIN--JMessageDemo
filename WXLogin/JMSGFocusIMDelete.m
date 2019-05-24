//
//  JMSGFocusIMDelete.m
//  JMessageDemo
//
//  Created by xudong.rao.com on 2018/11/28.
//  Copyright © 2018年 HXHG. All rights reserved.
//

#import "JMSGFocusIMDelete.h"
#import "AppDelegate.h"
#import <JMessage/JMessage.h>
#import "ChatMessageModel.h"
@interface JMSGFocusIMDelete ()<JMessageDelegate>{
    UIAlertView *alertView;
    UIAlertView *loginAlertView;
}
@end

@implementation JMSGFocusIMDelete


static JMSGFocusIMDelete *instance = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[JMSGFocusIMDelete alloc]init];
        
    });
    return instance;
}
- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}


#pragma mark -
/// TODO: 不是所有监听都要设置全局监听，开着可以根据自己需要，将代理添加在合适的页面
#pragma mark -

- (void)addJMDelegate {
    [JMessage addDelegate:self withConversation:nil];
}


#pragma mark - 数据库升级
- (void)onDBMigrateStart {
    NSLog(@"onDBmigrateStart in appdelegate");
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.isDBMigrating = YES;
}
- (void)onDBMigrateFinishedWithError:(NSError *)error {
    NSLog(@"onDBmigrateFinish in appdelegate");
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.isDBMigrating = NO;
}


-(void)onReceiveMessage:(JMSGMessage *)message error:(NSError *)error{
//    message.contentType;
////    /// 文本消息
////    kJMSGContentTypeText = 1,
////    /// 图片消息
////    kJMSGContentTypeImage = 2,
////    /// 语音消息
////    kJMSGContentTypeVoice = 3,
   
    [self makeMessage:message];
    
}
//离线消息
- (void)onSyncOfflineMessageConversation:(JMSGConversation *)conversation offlineMessages:(NSArray<__kindof JMSGMessage *> *)offlineMessages{
    NSLog(@"离线消息-----%@",offlineMessages);
    for (JMSGMessage *message in offlineMessages) {
        [self makeMessage:message];
    }
}
-(void)makeMessage:(JMSGMessage *)message{
    ChatMessageModel *model = [ChatMessageModel initWithJMSGMessage:message];
    switch (model.groupEventType) {
        case GoroupRemoveGroupType:
            
           
            break;
            
	        default:
            break;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"IMReceiVeMessage" object:model];

}
#pragma mark - 用户登录状态变更
- (void)onReceiveUserLoginStatusChangeEvent:(JMSGUserLoginStatusChangeEvent *)event {
    NSLog(@"\n ===当前登录用户状态变更事件===\n");
    switch (event.eventType) {
        case kJMSGEventNotificationLoginKicked:
            NSLog(@"login user notification event: Kicked.");
            break;
        case kJMSGEventNotificationServerAlterPassword:
            NSLog(@"login user notification event: alter password.");
            break;
        case kJMSGEventNotificationUserLoginStatusUnexpected:
            NSLog(@"login user notification event: status unexpected.");
            break;
        case kJMSGEventNotificationCurrentUserDeleted:
            NSLog(@"login user notification event: deleted.");
            break;
        case kJMSGEventNotificationCurrentUserDisabled:
            NSLog(@"login user notification event: disabled.");
            break;
        case kJMSGEventNotificationCurrentUserInfoChange:
            NSLog(@"login user notification event: info change.");
            break;
        default:
            break;
    }
    
    if (event.eventType == kJMSGEventNotificationCurrentUserInfoChange) {
        if (!loginAlertView) {
            loginAlertView = [[UIAlertView alloc] initWithTitle:@"登录状态异常"
                                                        message:@"当前用户登录状态异常，请重新登录。"
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"重新登录",nil];
        }
        loginAlertView.tag = 1001;
        [loginAlertView show];
    }else{
        [self showTitle:@"登录状态出错" message:event.eventDescription];
    }
}

#pragma mark - 好友相关事件

- (void)onReceiveFriendNotificationEvent:(JMSGFriendNotificationEvent *)event {
    NSLog(@"\n ===好友相关事件===\n:");
    switch (event.eventType) {
        case kJMSGEventNotificationReceiveFriendInvitation:
        case kJMSGEventNotificationAcceptedFriendInvitation:
        case kJMSGEventNotificationDeclinedFriendInvitation:
        case kJMSGEventNotificationDeletedFriend: {
            NSLog(@"Friend Notification Event");
           
        }
            break;
        case kJMSGEventNotificationReceiveServerFriendUpdate:
            NSLog(@"Receive Server Friend update Notification Event");
            break;
        default:
            break;
    }
}

#pragma mark - 公开群相关事件

- (void)onReceiveApplyJoinGroupApprovalEvent:(JMSGApplyJoinGroupEvent *)event {
    NSLog(@"\n\n ====== 收到申请入群事件 ====== \n eventID: %@ \n gid: %@ \n 邀请人: %@ \n 被邀请人: %@ \n",event.eventID,event.groupID,event.sendApplyUser,event.joinGroupUsers);
    

}

- (void)onReceiveGroupAdminRejectApplicationEvent:(JMSGGroupAdminRejectApplicationEvent *)event {
    NSLog(@"\n\n ====== 管理员拒绝入群申请 ======\n 群 gid:%@，管理员：%@， 拒绝原因：%@ \n",event.groupID,event.groupManager,event.rejectReason);
}

- (void)onReceiveGroupAdminApprovalEvent:(JMSGGroupAdminApprovalEvent *)event{
    NSLog(@"\n\n ====== 管理员审批事件 ======\n 群 gid:%@，%@ \n",event.groupID,event.isAgreeApply?@"同意":@"拒绝");
}


#pragma mark - 群组相关事件

- (void)onReceiveGroupNicknameChangeEvents:(NSArray<__kindof JMSGGroupNicknameChangeEvent *> *)events {
    JMSGGroup *group = nil;
    NSMutableArray *array = [NSMutableArray array];
    for (JMSGGroupNicknameChangeEvent *event in events) {
        group = event.group;
        NSString *string = [NSString stringWithFormat:@"修改者: %@，被修改者:%@，群昵称：%@，修改时间:%llu",event.fromMemberInfo.displayName,event.toMemberInfo.user.displayName,event.toMemberInfo.groupNickname,event.ctime];
        [array addObject:string];
    }
    NSString *str = [array componentsJoinedByString:@"\n"];
    [self showTitle:@"群成员昵称修改事件" message:str];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"\n ====== 群成员昵称修改事件 ====== \n group:%@,\n %@ \n",group,jsonStr);
}

- (void)onReceiveGroupBlacklistChangeEvents:(NSArray<__kindof JMSGGroupBlacklistChangeEvent *> *)events {
    JMSGGroup *group = nil;
    NSMutableArray *array = [NSMutableArray array];
    for (JMSGGroupBlacklistChangeEvent *event in events) {
        group = event.group;
        NSString *nameStr = @"";
        for (JMSGUser *target in event.targetList) {
            nameStr = [nameStr stringByAppendingFormat:@"%@ ",target.displayName];
        }
        NSString *typeStr = event.eventType == kJMSGEventNotificationAddGroupBlacklist ? @"加入":@"移除";
        NSString *string = [NSString stringWithFormat:@"%@ - 将 -【%@】- %@ - 群黑名单",event.fromUser.displayName,nameStr,typeStr];
        [array addObject:string];
    }
    NSString *str = [array componentsJoinedByString:@"\n"];
    [self showTitle:@"群组黑名单事件" message:str];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"\n ====== 群组黑名单事件 ====== \n group:%@,\n %@ \n",group,jsonStr);
}
- (void)onReceiveGroupAnnouncementEvents:(NSArray<__kindof JMSGGroupAnnouncementEvent *> *)events {
    JMSGGroup *group = nil;
    NSMutableArray *array = [NSMutableArray array];
    for (JMSGGroupAnnouncementEvent *event in events) {
        group = event.group;
        JMSGGroupAnnouncement *model = event.announcement;
        NSString *typeStr = @"";
        switch (event.eventType) {
            case kJMSGEventNotificationPublishGroupAnnouncement:
                typeStr = @"发布";
                break;
            case kJMSGEventNotificationDeleteGroupAnnouncement:
                typeStr = @"删除";
                break;
            case kJMSGEventNotificationTopGroupAnnouncement:
                typeStr = model.isTop ? @"置顶" : @"取消置顶";
                break;
            default:
                break;
        }
        NSString *string = [NSString stringWithFormat:@"操作者：%@ - 群公告 ID：%@ - 事件类型：%@",event.fromUser.displayName,@(model.announcementId),typeStr];
        [array addObject:string];
    }
    NSString *str = [array componentsJoinedByString:@"\n"];
    [self showTitle:@"群公告事件" message:str];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"\n ====== 群公告事件 ====== \n group:%@,\n %@ \n",group,jsonStr);
}

#pragma mark - 聊天室相关事件
- (void)onReceiveChatRoomAdminChangeEvents:(NSArray<__kindof JMSGChatRoomAdminChangeEvent *> *)events{
    NSMutableArray *array = [NSMutableArray array];
    JMSGChatRoom *chatRoom = nil;
    for (JMSGChatRoomAdminChangeEvent *event in events) {
        chatRoom = event.chatRoom;
        NSString *typeStr = @"";
        if (event.eventType == kJMSGEventNotificationChatRoomAddAdmin) {
            typeStr = @"加入";
        }else{
            typeStr = @"移除";
        }
        NSString *nameStr = @"";
        for (JMSGUser *user in event.targetList) {
            nameStr = [nameStr stringByAppendingFormat:@"%@ ",user.displayName];
        }
        NSString *string = [NSString stringWithFormat:@"%@ - 将【%@】%@ 管理员列表 - room:%@(%@)",event.fromUser.displayName,nameStr,typeStr,event.chatRoom.displayName,event.chatRoom.roomID];
        [array addObject:string];
    }
    NSString *str = [array componentsJoinedByString:@"\n"];
    [self showTitle:@"聊天室管理员变更事件" message:str];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"\n ====== 聊天室管理员变更事件 ====== \n  chatRoom:%@,\n %@ \n",chatRoom,jsonStr);
}

- (void)onReceiveChatRoomBlacklistChangeEvents:(NSArray<__kindof JMSGChatRoomBlacklisChangetEvent *> *)events{
    NSMutableArray *array = [NSMutableArray array];
    JMSGChatRoom *chatRoom = nil;
    for (JMSGChatRoomAdminChangeEvent *event in events) {
        chatRoom = event.chatRoom;
        NSString *typeStr = @"";
        if (event.eventType == kJMSGEventNotificationChatRoomAddBlacklist) {
            typeStr = @"加入";
        }else{
            typeStr = @"移除";
        }
        NSString *nameStr = @"";
        for (JMSGUser *user in event.targetList) {
            nameStr = [nameStr stringByAppendingFormat:@"%@ ",user.displayName];
        }
        NSString *string = [NSString stringWithFormat:@"%@ - 将【%@】%@ 黑名单列表 - room:%@(%@) ",event.fromUser.displayName,nameStr,typeStr,event.chatRoom.displayName,event.chatRoom.roomID];
        [array addObject:string];
    }
    NSString *str = [array componentsJoinedByString:@"\n"];
    [self showTitle:@"聊天室黑名单变更事件" message:str];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"\n ====== 聊天室黑名单变更事件 ====== \n  chatRoom:%@,\n %@ \n",chatRoom,jsonStr);
}
- (void)onReceiveChatRoomSilenceEvents:(NSArray<__kindof JMSGChatRoomSilenceEvent *> *)events{
    NSMutableArray *array = [NSMutableArray array];
    JMSGChatRoom *chatRoom = nil;
    for (JMSGChatRoomAdminChangeEvent *event in events) {
        chatRoom = event.chatRoom;
        NSString *typeStr = @"";
        if (event.eventType == kJMSGEventNotificationChatRoomAddSilence) {
            typeStr = @"加入";
        }else{
            typeStr = @"移除";
        }
        NSString *nameStr = @"";
        for (JMSGUser *user in event.targetList) {
            nameStr = [nameStr stringByAppendingFormat:@"%@ ",user.displayName];
        }
        NSString *string = [NSString stringWithFormat:@"%@ - 将【%@】%@ 禁言列表 - room:%@(%@) ",event.fromUser.displayName,nameStr,typeStr,event.chatRoom.displayName,event.chatRoom.roomID];
        [array addObject:string];
    }
    NSString *str = [array componentsJoinedByString:@"\n"];
    [self showTitle:@"聊天室禁言变更事件" message:str];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSLog(@"\n ====== 聊天室禁言变更事件 ====== \n  chatRoom:%@,\n %@ \n",chatRoom,jsonStr);
}

#pragma mark - alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView == loginAlertView) {
        NSLog(@"登录");
    }
}


#pragma mark - 弹框
- (void)showTitle:(NSString *)title message:(NSString *)message {
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"run on simulator");
#else
    NSLog(@"run on device");
    if (!alertView) {
        alertView = [[UIAlertView alloc] initWithTitle:title
                                               message:message
                                              delegate:nil
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"OK",nil];
        
    }
    if (alertView) {
        [alertView setTitle:title];
        [alertView setMessage:message];
        [alertView show];
    }
#endif
}

#pragma mark - 过期方法
/*
 - (void)onLoginUserKicked{
 }
 - (void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event{
 NSLog(@"Action - onReceiveNotificationEvent:");
 }
 
 - (void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event{
 
 }
 */

@end
