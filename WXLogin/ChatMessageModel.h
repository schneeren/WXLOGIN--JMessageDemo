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

typedef NS_ENUM(NSInteger,MessageType) {
    /// 已发送成功的消息
    haveSendSuccessedType = 0,
    /// 发送中
    isSendType = 1,
    /// 发送失败
    haveSendFailedType = 2,
};

@interface ChatMessageModel : JMSGMessage


@property (nonatomic, strong) NSString *name;//昵称

@property (nonatomic, strong) NSString *userName;//账户

@property (nonatomic, strong) NSString *messageText;//文本信息

@property (nonatomic) MessageType messageStatus;

+(instancetype)initWithJMSGMessage:(JMSGMessage *)SGMessage;

-(void)loadThumbnailUserHeadImage:(void(^)(NSData *data))complete;//加载用户缩略头像

-(void)loadLargeUserHeadImage:(void(^)(NSData *data))complete;//加载用户头像大图


@end

NS_ASSUME_NONNULL_END
