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
    NSLog(@"走这里了");
    return self.fromUser.nickname;
    
}
-(NSString *)userName{
    
    return self.fromUser.username;
}
-(NSString *)messageText{
    
     return  ((JMSGTextContent *)self.content).text;
    
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
