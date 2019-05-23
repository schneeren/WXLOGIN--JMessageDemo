//
//  JMSGFocusIMDelete.h
//  JMessageDemo
//
//  Created by xudong.rao.com on 2018/11/28.
//  Copyright © 2018年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JMessage/JMessage.h>
NS_ASSUME_NONNULL_BEGIN

@interface JMSGFocusIMDelete : NSObject

@property (nonatomic, copy) void (^message)(NSData *data);

+ (instancetype)sharedManager;
- (void)addJMDelegate;
-(void)makeMessage:(JMSGMessage *)message;
@end

NS_ASSUME_NONNULL_END
