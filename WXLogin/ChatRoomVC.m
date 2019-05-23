//
//  ChatRoomVC.m
//  WXLogin
//
//  Created by RenShen on 2019/5/22.
//  Copyright © 2019 RenShen. All rights reserved.
//

#import "ChatRoomVC.h"
#import "ChatRoomManager.h"
#import "ChatMessageModel.h"
#import <YYKit.h>
#define WEAKSELF  __weak __typeof(&*self)weakSelf = self;
#define StrNoNull(str) (str == nil || [str isKindOfClass:[NSNull class]] || [str isEqual: @"null"])?@"":str
@interface ChatRoomVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *textfiled;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ChatRoomManager *manager;
@property (nonatomic, strong) JMSGConversation *conversation;
@property (nonatomic, strong) NSMutableArray *messageArray;
@end

@implementation ChatRoomVC
+(instancetype)creatChatRoomWithJMSGConversation:(JMSGConversation *)conversation{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ChatRoomVC *chatRoom = [sb instantiateViewControllerWithIdentifier:@"ChatRoomVC"];
    chatRoom.conversation = [conversation modelCopy];
    return chatRoom;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _messageArray = [NSMutableArray array];
    WEAKSELF;
    _manager = [[ChatRoomManager alloc]initWithJMSGConversation:self.conversation Complete:^(BOOL success) {
        if (success) {
            NSLog(@"房间创建成立");
            [weakSelf loadMoreMessage];
            weakSelf.title = weakSelf.manager.roomName;
        }else{
            NSLog(@"房间创建失败");
        }
    }];
}
-(void)loadMoreMessage{
    WEAKSELF;
    [_manager getMoreMessageWithIndex:_messageArray.count Complete:^(NSArray<ChatMessageModel *> * _Nonnull newMessagArray) {
            [newMessagArray reverseObjectEnumerator];
        [weakSelf.messageArray addObjectsFromArray:newMessagArray];
        [weakSelf.tableView reloadData];
    }];
    
    _manager.sendManager.receiveMessage = ^(ChatMessageModel *messageModel) {
        [weakSelf.messageArray addObject:messageModel];
        [weakSelf.tableView reloadData];
    };
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.messageArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"roomCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    ChatMessageModel *model = _messageArray[indexPath.section];
    cell.textLabel.text = StrNoNull(model.name);
//    [model loadLargeUserHeadImage:^(NSData * _Nonnull data) {
//
//    }];
    cell.detailTextLabel.text = StrNoNull(model.messageText);
    return cell;
}
- (IBAction)sendMessage:(id)sender {
    
    if (_textfiled.text.length == 0) {
        NSLog(@"不能发空白信息");
        return;
    }
    
    ChatMessageModel *model =  [_manager.sendManager sendTextMessage:_textfiled.text];
    [_messageArray addObject:model];
    [_tableView reloadData];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
