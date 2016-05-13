//
//  NetworkManager.m
//  GitHubClient
//
//  Created by zack on 16/5/13.
//  Copyright © 2016年 臧其龙. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager
+ (id)shareNetworkManagerObject {
    static NetworkManager *networkManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[NetworkManager alloc] init];
    });
    return networkManager;
}



@end
