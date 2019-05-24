//
//  ChatRoomModel.h
//  WXLogin
//
//  Created by RenShen on 2019/5/22.
//  Copyright © 2019 RenShen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JMessage/JMessage.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,MessageStatus) {
    /// 已发送成功的消息
    MessageStatusHaveSendSuccessedStatus = 0,
    /// 发送中
    MessageStatusIsSendStatus = 1,
    /// 发送失败
    MessageStatusHaveSendFailedStatus = 2,
};

typedef NS_ENUM(NSInteger,GroupEventType) {
    //未知事件,什么事情都不做
    GroupEventUNKnowType = 0,
    //退出群组，退出聊天界面
    GroupEventExitType = 1,
    //群成员变更
    GroupMembersChangeType = 2,
    //群信息变更，刷新群信息
    GroupInfoChangeType = 3,
    //群已解散，退出聊天界面
    GroupDissolveType = 4,
    //被提出群
    GoroupRemoveGroupType = 5,
};

@interface ChatMessageModel : JMSGMessage


@property (nonatomic, strong) NSString *name;//昵称

@property (nonatomic, strong) NSString *userName;//账户

@property (nonatomic, strong) NSString *messageText;//文本信息

@property (nonatomic) MessageStatus messageStatus;

@property (nonatomic) GroupEventType groupEventType;

+(instancetype)initWithJMSGMessage:(JMSGMessage *)SGMessage;

-(void)loadThumbnailUserHeadImage:(void(^)(NSData *data))complete;//加载用户缩略头像

-(void)loadLargeUserHeadImage:(void(^)(NSData *data))complete;//加载用户头像大图

-(void)loadThumbnailMessageImage:(void(^)(NSData *data))complete;//加载信息缩略图

-(void)loadLargeMessageImage:(void(^)(NSData *data))complete;//加载信息大图
@end

NS_ASSUME_NONNULL_END
