//
//  GithubHttpClient.m
//  GitHubClient
//
//  Created by 臧其龙 on 16/5/1.
//  Copyright © 2016年 臧其龙. All rights reserved.
//

#import "GithubHttpClient.h"
#import "GithubHttCongifuration.h"
#import "AFHTTPSessionManager.h"
#import "AFURLRequestSerialization.h"
#import "AFURLResponseSerialization.h"
#import "NSUserDefaults+TokenAccess.h"

@interface GithubHttpClient ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) GithubHttCongifuration *configure;

@end

@implementation GithubHttpClient

#pragma mark - Init Method
+ (instancetype)sharedInstance {
    static GithubHttpClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GithubHttpClient alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    if(self = [super init])
    {
        _manager = [AFHTTPSessionManager manager];
        _configure = [GithubHttCongifuration sharedInstance];
    }
    return  self;
}

#pragma mark - Private Method
- (NSString *)buildRequestURL:(GithubRequest *)request
{
    NSString *finalURL = request.requestURL;
    if ([finalURL hasPrefix:@"http"]) {
        return finalURL;
    }
    
    NSString *baseURL = nil;
    if (request.baseURL.length > 0) {
        baseURL = request.baseURL;
    }else if(_configure.baseURL.length > 0){
        baseURL = _configure.baseURL;
    }
    
    return [NSString stringWithFormat:@"%@%@", baseURL, request.requestURL];
    
}

- (void)addRequest:(GithubRequest *)request
{
    NSLog(@"url is %@", request.requestURL);
    NSAssert(request.requestURL.length != 0, @"URL is empty");
    
    if (request.requestSerializerType == GithubRequestSerializerTypeHTTP) {
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == GithubRequestSerializerTypeJSON) {
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [self addAuthorizationForHttpHeader];
    
    AFJSONResponseSerializer *responseSerialization = [AFJSONResponseSerializer serializer];
    
    if (request.extraHttpHeaders) {
        
        NSArray *keys = request.extraHttpHeaders.allKeys;
        for (NSString *key in keys) {
            [_manager.requestSerializer setValue:request.extraHttpHeaders[key] forHTTPHeaderField:key];
        }
    }
    
    NSString *etag = [[request class] getEtag];
    if (etag.length > 0) {
        [_manager.requestSerializer setValue:etag forHTTPHeaderField:@"If-None-Match"];
        _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    }
    
    if (request.acceptResponseContentType) {
        NSMutableSet *acceptSet = [responseSerialization.acceptableContentTypes mutableCopy];
        [acceptSet addObjectsFromArray:request.acceptResponseContentType];
    }
    
    NSMutableIndexSet *set = [[responseSerialization acceptableStatusCodes] mutableCopy];
    [set addIndex:304];
   
    responseSerialization.acceptableStatusCodes = set;
     NSLog(@"set is %@", responseSerialization.acceptableStatusCodes );
    _manager.responseSerializer = responseSerialization;
    
    if (request.requestMethod == GithubRequestMethodGet) {
        
        request.sessionDataTask = [_manager GET:[self buildRequestURL:request] parameters:request.requestBody progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)task.response;
            if ([httpResponse respondsToSelector:@selector(allHeaderFields)]) {
                NSDictionary *dictionary = [httpResponse allHeaderFields];
                NSString *etag = dictionary[@"Etag"];
                if (etag.length > 0) {
                    if ([request isKindOfClass:[GithubRequest class]]) {
                        [[request class] setEtag:etag];
                    }
                }
                NSLog(@"status code is%d",httpResponse.statusCode);
            }
            if (request.requestFinishedCallback) {
                request.requestFinishedCallback(nil, responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (request.requestFinishedCallback) {
                request.requestFinishedCallback(error, nil);
            }
        }];
    }
    
    if(request.requestMethod == GithubRequestMethodPost){
        request.sessionDataTask = [_manager POST:[self buildRequestURL:request] parameters:request.requestBody progress:^(NSProgress * _Nonnull uploadProgress) {
        
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (request.requestFinishedCallback) {
                request.requestFinishedCallback(nil, responseObject);
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (request.requestFinishedCallback) {
                request.requestFinishedCallback(error, nil);
            }

        }];
    }
}

- (void)addAuthorizationForHttpHeader
{
    NSString *token = [[NSUserDefaults standardUserDefaults] getToken];
    NSString *tokenType = [[NSUserDefaults standardUserDefaults] getTokenType];
    if (token.length > 0 && tokenType.length > 0) {
        NSString *authorization = [NSString stringWithFormat:@"%@ %@",@"token", token];
        [_manager.requestSerializer setValue:authorization forHTTPHeaderField:@"Authorization"];
    }
}


@end
