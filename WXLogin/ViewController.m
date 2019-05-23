//
//  ViewController.m
//  WXLogin
//
//  Created by RenShen on 2019/5/20.
//  Copyright © 2019 RenShen. All rights reserved.
//

#import "ViewController.h"
#import <WXApi.h>
#import <AFNetworking.h>
#import <JPUSHService.h>
#import <JMessage/JMessage.h>
#import "JMSGFocusIMDelete.h"
#import "ChatRoomVC.h"
@interface ViewController ()<WXApiDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) NSArray *messageRoomArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCode:) name:@"weixin" object:nil];
    
    [JMSGFocusIMDelete sharedManager].message = ^(NSData *data) {
        self.imageView.image = [UIImage imageWithData:data];
    };
    NSNumber * unRead =  [JMSGConversation getAllUnreadCount];
    NSLog(@"未读消息数-----%ld",(long)unRead.integerValue);
}

- (IBAction)WXLogin:(id)sender {
    
    if (![WXApi isWXAppInstalled]) {
        NSString *account = @"neighbor7";
        [JMSGUser loginWithUsername:account password:account completionHandler:^(id resultObject, NSError *error) {
            NSLog(@"result---%@",resultObject);
            NSLog(@"error---%@",error);
            
            NSLog(@"userinfo----%@",[JMSGUser myInfo]);
        }];
    }
    SendAuthReq *req = [[SendAuthReq alloc]init];
    
    req.state = @"wxLogin";
    req.scope = @"snsapi_userinfo";//授权作用域：获取用户个人信息
    
    [WXApi sendAuthReq:req viewController:self delegate:self];
}
-(void)getCode:(NSNotification *)notification{
    
    NSString *code = notification.userInfo[@"code"];
    NSLog(@"code----%@",code);
//
    AFHTTPSessionManager *session = [[AFHTTPSessionManager alloc]init];
//    session.requestSerializer  = [AFJSONRequestSerializer serializer];
//    session.responseSerializer = [AFJSONResponseSerializer serializer];
//    session.securityPolicy.validatesDomainName = NO;
//    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html" ,@"text/plain",nil];
//    NSString *secret = @"";
//    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=wx7d4ad3d1fe31ccb8&secret=%@&code=%@&grant_type=authorization_code",secret,code];
//
//    [session GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"response---%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error---%@",error);
//    }];

//    [session÷/]
    NSString *url = @"http://jiekou.nb-plus.com/neighbor/api/login";
    NSDictionary *parameter = @{@"code":code};
    NSLog(@"parameter ----%@",parameter);
    [session POST:url parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObj----%@",responseObject);
        NSDictionary *dic = responseObject[@"obj"];
        NSDictionary *user = dic[@"user"];
        NSString *userid = user[@"id"];
        NSString *account =[NSString stringWithFormat:@"neighbor%@",userid];
        [JPUSHService setAlias:account completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"%ld\n%@\n%ld\n",(long)iResCode,iAlias,(long)seq);
        } seq:321];
        
        JMSGUserInfo *info = [[JMSGUserInfo alloc] init];
        info.nickname =user[@"nickName"];

      


        [JMSGUser registerWithUsername:account
                              password:account
                              userInfo:info
                     completionHandler:^(id resultObject, NSError *error) {
                         NSLog(@"111result---%@",resultObject);
                         NSLog(@"111error---%@",error);
                         
                         [JMSGUser loginWithUsername:account password:account completionHandler:^(id resultObject, NSError *error) {
                             NSLog(@"result---%@",resultObject);
                             NSLog(@"error---%@",error);
                             
                             NSLog(@"userinfo----%@",[JMSGUser myInfo]);
                         }];
        }];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
   NSNumber * unRead =  [JMSGConversation getAllUnreadCount];
    NSLog(@"未读消息数-----%ld",(long)unRead.integerValue);
}

- (IBAction)gotoChat:(id)sender {
    //创建聊天室
   [JMSGConversation createSingleConversationWithUsername:@"2480505717@qq.com" completionHandler:^(id resultObject, NSError *error) {
        NSLog(@"resultObject--%@",resultObject);
       JMSGConversation *JMSG =(JMSGConversation *)resultObject;
       [JMSG allMessages:^(id resultObject, NSError *error) {
                   NSLog(@"------%@",resultObject);
                   for (JMSGMessage *message in resultObject) {
                        [[JMSGFocusIMDelete sharedManager]makeMessage:message];
                   }
       }];
       
//       [JMSG sendTextMessage:@"收到"];
    }];
//    //获取跟他的所有信息
//    JMSGConversation *jmsg = [JMSGConversation singleConversationWithUsername:@"2480505717@qq.com"];
//
//    [jmsg allMessages:^(id resultObject, NSError *error) {
//        NSLog(@"------%@",resultObject);
//        for (JMSGMessage *message in resultObject) {
//             [[JMSGFocusIMDelete sharedManager]makeMessage:message];
//        }
//
//    }];
}

- (IBAction)allMessage:(id)sender {
    NSNumber * unRead =  [JMSGConversation getAllUnreadCount];
    NSLog(@"所有未读消息数-----%ld",(long)unRead.integerValue);
    
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        NSLog(@"resultObject----%@",resultObject);
        self.messageRoomArray = (NSArray *)resultObject;
        for (JMSGConversation *JMSG  in resultObject) {
            NSNumber * unRead =  JMSG.unreadCount;
            NSLog(@"第一个列表未读消息数-----%ld",(long)unRead.integerValue);
            [JMSG allMessages:^(id resultObject, NSError *error) {
                JMSGMessage *message = resultObject[0];
                [[JMSGFocusIMDelete sharedManager]makeMessage:message];
                
            }];
            [JMSG clearUnreadCount];
        }
    }];
    
}
- (IBAction)jumpChatRoom:(id)sender {
    if ([[JMSGUser myInfo].username isEqualToString:@"neighbor7"]) {
        [JMSGConversation createSingleConversationWithUsername:@"neighbor12" completionHandler:^(id resultObject, NSError *error) {
            NSLog(@"resultObject--%@",resultObject);
            
            JMSGConversation *JMSG =(JMSGConversation *)resultObject;
            
            ChatRoomVC *room = [ChatRoomVC creatChatRoomWithJMSGConversation:JMSG];
            
            [self.navigationController pushViewController:room animated:YES];
        }];
    }else{
    JMSGConversation *conversation = _messageRoomArray[0];
    
    ChatRoomVC *room = [ChatRoomVC creatChatRoomWithJMSGConversation:conversation];
    
    [self.navigationController pushViewController:room animated:YES];
    }
}

@end
