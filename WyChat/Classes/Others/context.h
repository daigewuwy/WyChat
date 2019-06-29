//
//  context.h
//  WyChat
//
//  Created by 吴伟毅 on 19/6/9.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface context : NSObject
{
    FMDatabaseQueue *_queue;
}

+ (context *)sharedInstance;
@property(strong, nonatomic, readwrite) FMDatabaseQueue *queue;
@end
