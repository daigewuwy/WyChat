//
//  WCMediator.m
//  WyChat
//
//  Created by 吴伟毅 on 19/6/16.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "WCMediator.h"

@implementation WCMediator

+(UIViewController *)chatComponent_viewControllerWithChatter:(NSString *)conversationChatter conversationType:(EMConversationType)type {
    
    Class cls = NSClassFromString(@"WCChatComponent");
    UIViewController *vc = [cls performSelector:NSSelectorFromString(@"chatViewControllerWithChatter:conversationType:") withObject:conversationChatter withObject:@(type)];
    return vc;
    
}   
@end
