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
#import "ListVC.h"
#import "EmojiView.h"
@interface ViewController ()<WXApiDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
//单聊
@property (nonatomic, strong) NSMutableArray *messageRoomArray;
//群聊
@property (nonatomic, strong) NSMutableArray *messageRroupArray;

@property (nonatomic, weak) ListVC *weaklistVC;
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:@"IMReceiVeMessage" object:nil];
    NSDictionary *string = @{@"11":@"33"};


    [self change:string];
    NSLog(@"%@",string);
    //txt转为plist
    NSString *file = [[NSBundle mainBundle]pathForResource:@"face" ofType:@"txt"];
    NSString *txt = [[NSString alloc]initWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];

    NSLog(@"txt---%@",txt);
    NSArray *array = [txt componentsSeparatedByString:@"\n"];
    NSMutableArray *plist = [NSMutableArray array];
    for (NSString *string in array) {
        NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
        NSArray *splitString = [string componentsSeparatedByCharactersInSet:delimiters];

        NSString *key = [NSString stringWithFormat:@"[%@]",splitString[1]];


        NSRange range = [string rangeOfString:@"face_qq_"];
        NSString *str = [string substringFromIndex:(range.location)];

        str = [str stringByReplacingOccurrencesOfString:@");" withString:@""];
        NSDictionary *dic = @{
                              @"name":key,
                              @"image":str
                              };
        [plist addObject:dic];
    }
    NSLog(@"plist----%@",plist);

    [plist writeToFile:@"/Users/renshen/Desktop/CC/emoji.plist" atomically:YES];
    
    
}
-(void)change:(NSDictionary *)str{
    str = @{@"11":@"22"};
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (IBAction)WXLogin:(id)sender {
    
    if (![WXApi isWXAppInstalled]) {
        NSString *account = @"neighbor7";
        [JMSGUser loginWithUsername:account password:account completionHandler:^(id resultObject, NSError *error) {
            NSLog(@"result---%@",resultObject);
            NSLog(@"error---%@",error);
            
            NSLog(@"userinfo----%@",[JMSGUser myInfo]);
        }];
        return;
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



- (IBAction)allMessage:(id)sender {
    NSNumber * unRead =  [JMSGConversation getAllUnreadCount];
    NSLog(@"所有未读消息数-----%ld",(long)unRead.integerValue);
    
    [self reloadData];
    
}
-(void)reloadData{

    //不包括聊天室会话，默认是已经排序。单聊和群组信息
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        self.messageRoomArray = [NSMutableArray array];
        self.messageRroupArray = [NSMutableArray array];
        [resultObject enumerateObjectsUsingBlock:^(JMSGConversation *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.conversationType == kJMSGConversationTypeSingle){
                
                [self.messageRoomArray addObject:obj];
            }
            if (obj.conversationType == kJMSGConversationTypeGroup) {
                [self.messageRroupArray addObject:obj];
            }
        }];
        NSLog(@"单聊###############\n%@",self.messageRoomArray);
        NSLog(@"群聊####################\n%@",self.messageRroupArray);
        
        if (self.weaklistVC) {
            
            if (self.weaklistVC.chatType == 0) {
                self.weaklistVC.listArray = self.messageRoomArray;
            }else{
                self.weaklistVC.listArray = self.messageRroupArray;
                
            }
            [self.weaklistVC reloadList];
        }
    }];
    
    //聊天室，不包括单聊和群聊会话，默认是已经排序。
    [JMSGConversation allChatRoomConversation:^(id resultObject, NSError *error) {
        NSLog(@"聊天室resultObject----%@",resultObject);
        
    }];
    

    
}
//单聊
- (IBAction)jumpChatRoom:(id)sender {
//    if ([[JMSGUser myInfo].username isEqualToString:@"neighbor7"]) {
//        [JMSGConversation createSingleConversationWithUsername:@"neighbor12" completionHandler:^(id resultObject, NSError *error) {
//            NSLog(@"resultObject--%@",resultObject);
//
//            JMSGConversation *JMSG =(JMSGConversation *)resultObject;
//
//            ChatRoomVC *room = [ChatRoomVC creatChatRoomWithJMSGConversation:JMSG];
//
//            [self.navigationController pushViewController:room animated:YES];
//        }];
//    }else{
//        if (_messageRoomArray.count>0) {
//            JMSGConversation *conversation = _messageRoomArray[0];
//
//            ChatRoomVC *room = [ChatRoomVC creatChatRoomWithJMSGConversation:conversation];
//
//            [self.navigationController pushViewController:room animated:YES];
//        }else{
//
//            NSLog(@"没有聊天");
//        }
//
//    }
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle ]];
    ListVC *vc = [sb instantiateViewControllerWithIdentifier:@"ListVC"];
    vc.listArray = [_messageRoomArray mutableCopy];
    vc.chatType  = 0;
    _weaklistVC = vc;
     [self.navigationController pushViewController:vc animated:YES];
}
//群组
- (IBAction)gotoChat:(id)sender {
    EmojiView *emoji = [[EmojiView alloc]initWithFrame:CGRectMake(12, 100, [UIScreen mainScreen].bounds.size.width-24, 240)];
    
    [self.view addSubview:emoji];
    return;
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle ]];
    ListVC *vc = [sb instantiateViewControllerWithIdentifier:@"ListVC"];
    vc.listArray = [_messageRroupArray mutableCopy];
    vc.chatType = 1;
    _weaklistVC = vc;
    [self.navigationController pushViewController:vc animated:YES];
    
//    if (_messageRroupArray.count>0) {
//        JMSGConversation *conversation = _messageRroupArray[0];
//
//        ChatRoomVC *room = [ChatRoomVC creatChatRoomWithJMSGConversation:conversation];
//
//        [self.navigationController pushViewController:room animated:YES];
//    }else{
//
//        NSLog(@"没有聊天");
//    }
}


@end
