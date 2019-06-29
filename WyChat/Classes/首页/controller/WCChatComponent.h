//
//  WCChatComponent.h
//  WyChat
//
//  Created by 吴伟毅 on 19/6/16.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCChatComponent : NSObject
+ (UIViewController *)chatViewControllerWithChatter:(NSString *)chatter conversationType:(NSNumber *)type;
@end
