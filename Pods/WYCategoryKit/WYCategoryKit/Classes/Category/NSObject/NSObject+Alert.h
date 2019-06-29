//
//  NSObject+Alert.h
//
//  Created by wwy on 2019/6/23.
//  Copyright © 2019 wwy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Alert)

- (void)showAlertWithMessage:(NSString *)aMsg;

- (void)showAlertWithTitle:(NSString *)aTitle
                   message:(NSString *)aMsg;

@end

NS_ASSUME_NONNULL_END
