//
//  NetworkManager.h
//  GitHubClient
//
//  Created by zack on 16/5/13.
//  Copyright © 2016年 臧其龙. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface NetworkManager : AFHTTPSessionManager
+ (id)shareNetworkManagerObject;
@end
