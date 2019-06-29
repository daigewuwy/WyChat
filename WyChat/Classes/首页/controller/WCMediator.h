//
//  WCMediator.h
//  WyChat
//
//  Created by 吴伟毅 on 19/6/16.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCMediator : NSObject
+ (UIViewController *)chatComponent_viewControllerWithChatter:(NSString *)conversationChatter conversationType:(EMConversationType)type;
@end
