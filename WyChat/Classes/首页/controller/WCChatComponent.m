//
//  WCChatComponent.m
//  WyChat
//
//  Created by 吴伟毅 on 19/6/16.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCChatComponent.h"
#import "WCChatVC.h"

@implementation WCChatComponent

+(UIViewController *)chatViewControllerWithChatter:(NSString *)chatter conversationType:(NSNumber *)type {
    
    WCChatVC *vc = [[WCChatVC alloc] initWithConversationChatter:chatter conversationType:(EMConversationType)type.integerValue];
    return vc;
    
}

@end
