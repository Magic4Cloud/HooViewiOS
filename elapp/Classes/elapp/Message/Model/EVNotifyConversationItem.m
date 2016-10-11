//
//  EVNotifyConversationItem.m
//  elapp
//
//  http://www.easyvaas.com
//  Copyright (c) 2016 EasyVass. All rights reserved.
//

#import "EVNotifyConversationItem.h"
#import "EVUserModel.h"
#import "EVLoginInfo.h"

@implementation EVNotifyConversationItem

- (void)setUpdate_time:(NSString *)update_time
{
    [super setUpdate_time:update_time];
    self.im_update_time = update_time;
}

- (void)setIm_update_time:(NSString *)im_update_time
{
    _im_update_time = im_update_time;
   [super setUpdate_time:im_update_time];
}

- (void)setConversation:(EMConversation *)conversation
{
    _conversation = conversation;
    //  此处需要从后台或者本地缓存获取环信号与云播号的联系,然后在此设置头像 图标,以及未读消息
    self.title =self.userModel.nickname;
    
    self.title = self.title.length == 0 ? @"''" : self.title;
    
    self.imuser = conversation.chatter;
    self.unread = conversation.unreadMessagesCount;
    
    // 设置最后一条消息
    [self setLastMessage:conversation.latestMessage];
    
    if ( self.currUserName == nil ) {
        EVLoginInfo *login = [EVLoginInfo localObject];
        self.currUserName = login.name;
    }
}

- (void)setLastMessage:(EMMessage *)latestMsg
{
    self.send_fail = latestMsg.deliveryState == eMessageDeliveryState_Failure;
    
    id<IEMMessageBody> body = [latestMsg.messageBodies firstObject];
    NSString *stampFormat = @"YYYY-MM-dd HH:mm:ss";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:stampFormat];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:latestMsg.timestamp / 1000];
    self.update_time = [formatter stringFromDate:date];
    
    if ([body isKindOfClass:[EMTextMessageBody class]]) {
        EMTextMessageBody *textBody = [latestMsg.messageBodies firstObject];
        if ([latestMsg.ext.allKeys containsObject:@"redpack"]) {
            self.content = kE_GlobalZH(@"message_red_pack");
        } else {
            self.content = textBody.text;
        }
    }
    else
    {
        switch ( [body messageBodyType] )
        {
            case eMessageBodyType_Image:
                if ( latestMsg.ext[kVid] )
                {
                    self.content = kE_GlobalZH(@"message_living");
                }
                else
                {
                    self.content = kE_GlobalZH(@"kMessage_image");
                }
                break;
                
            case eMessageBodyType_Voice:
                self.content = kE_GlobalZH(@"message_voice");
                break;
                
            case eMessageBodyType_Location:
                self.content = kE_GlobalZH(@"message_shared_position");
                break;
                
            default:
                self.content = kE_GlobalZH(@"message_new");
                break;
        }
    }
}

- (void)setUserModel:(EVUserModel *)userModel
{
    _userModel = userModel;
    self.icon = userModel.logourl;
    self.title = userModel.nickname;
    self.nickName = userModel.nickname;
    self.name = userModel.name;
}

- (BOOL)isEqual:(id)object
{
    if ( object == self )
    {
        return YES;
    }
    else if ( [object isKindOfClass:[EVNotifyConversationItem class]] )
    {
        return [self.conversation.chatter isEqualToString:[[object conversation] chatter]];
    }
    return NO;
}

#pragma mark - 重写数据库类要用的方法
+ (NSString *)keyColumn
{
    return @"imuser";
}

+ (NSString *)keyColumnType
{
    return COLUMN_TYPE_STRING;
}

+ (NSInteger)tableVersion
{
    return 7;
}

+ (NSDictionary *)ignoreProperties
{
    return @{@"Id" : @"Id",@"message_id" : @"message_id",@"groupid" : @"groupid", @"type" : @"type", @"total":@"total", @"lastest_content" :@"lastest_content",@"cellHeight": @"cellHeight",@"conversation" : @"conversation" , @"userModel" : @"userModel",@"update_time": @"update_time",@"nickName":@"nickName",@"name":@"name"};
}

+ (void)getConversationArrayFromDBStart:(NSInteger)start count:(NSInteger) count complete:(void (^)(NSArray *))complete
{
    EVLoginInfo *login = [EVLoginInfo localObject];
    if ( login.imuser == nil ) {
        if ( complete ) {
            complete(nil);
        }
        return;
    }
    CCQueryObject *query = [[CCQueryObject alloc] init];
    query.clazz = [self class];
    if ( login.name && ![login.name isEqualToString:@""] )
    {
        query.properties = @[@"currUserName"];
        query.properties_condition_values = @[login.name];
        query.properties_condition_symbol = @[CONDITION_SYMBOL_EQUAL];
    }
    query.start = start;
    query.count = count;
    query.tailSql = @" ORDER BY im_update_time DESC ";
    [EVNotifyConversationItem queryWithQueryObj:query complete:^(NSArray *resuls) {
        if ( resuls.count == 0 && complete )
        {
            complete(resuls);
            return ;
        }
        __block NSInteger index = 0;
        for (EVNotifyConversationItem *item in resuls)
        {
            [EVUserModel getUserInfoModelWithIMUser:item.imuser complete:^(EVUserModel *model) {
                index++;
                if ( model == nil )
                {
                    item.conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:item.imuser conversationType:eConversationTypeChat];
                }
                else
                {
                    item.userModel = model;
                    [item fillConverSationAfterFromLocal];
                }
                if ( index == resuls.count && complete ) {
                    complete(resuls);
                }
            }];
        }
    }];
}

- (void)fillConverSationAfterFromLocal
{
    self.conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.userModel.imuser conversationType:eConversationTypeChat];
}

@end
