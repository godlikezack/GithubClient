//
//  NetworkManager.m
//  GitHubClient
//
//  Created by zack on 16/5/13.
//  Copyright © 2016年 臧其龙. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworking.h"

@implementation NetworkManager
+ (id)shareManager{
    static NetworkManager *networkManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkManager = [[NetworkManager alloc] init];
    });
    return networkManager;
}

- (void)doAuthorizationWithCode:(NSString *)code
                        success:(void (^)(NSDictionary *))successBlock
                           fail:(void (^)())failBlock{
    NSArray *tempArr = [code componentsSeparatedByString:@"="];
    NSDictionary *dict = @{@"client_id":kClientID,
                           @"client_secret":kClientSecret,
                           @"code":[tempArr lastObject]};
    [self connectWithParams:dict httpUrl:kBaseUrl isPostMethod:YES success:^(NSDictionary *result) {
        NSLog(@"%s,line num = %d \n %@",__func__,__LINE__,result);
        if (successBlock) {
            successBlock(result);
        }
    } fail:^{
        
    }];
}



#pragma mark
#pragma mark - 统一请求方法
- (void)connectWithParams:(id)parameters
                  httpUrl:(NSString*)url
             isPostMethod:(BOOL)ispost
                  success:(void (^)(NSDictionary *result))successBlock
                     fail:(void (^)())failBlock
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString *token=USER_ValueForKey(kAccessToken);
    if (token.length>0) {
        NSString *authorization = [NSString stringWithFormat:@"%@ %@",@"token", token];
        [manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    
  if (ispost) {
        [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
        
    }
    else {
        [manager GET:url parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       if (successBlock) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            if (failBlock) {
                failBlock(error);
            }
        }];
    }
    
}


@end
