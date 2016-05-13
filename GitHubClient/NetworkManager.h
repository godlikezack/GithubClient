//
//  NetworkManager.h
//  GitHubClient
//
//  Created by zack on 16/5/13.
//  Copyright © 2016年 臧其龙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject
+ (id)shareManager;

- (void)doAuthorizationWithCode:(NSString *)code
                        success:(void (^)(NSDictionary *result))successBlock
                           fail:(void (^)())failBlock;


@end
