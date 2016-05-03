//
//  GithubRequest.h
//  GitHubClient
//
//  Created by 臧其龙 on 16/5/1.
//  Copyright © 2016年 臧其龙. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^GithubRequestCallback)(NSError *error, id result);

typedef NS_ENUM(NSInteger , GithubRequestMethod) {
    GithubRequestMethodGet = 0,
    GithubRequestMethodPost,
    GithubRequestMethodHead,
    GithubRequestMethodPut,
    GithubRequestMethodDelete,
    GithubRequestMethodPatch
};

typedef NS_ENUM(NSInteger , GithubRequestSerializerType) {
    GithubRequestSerializerTypeHTTP = 0,
    GithubRequestSerializerTypeJSON,
};

@interface GithubRequest : NSObject

@property (nonatomic, strong) NSURLSessionDataTask *sessionDataTask;
@property (nonatomic, copy) GithubRequestCallback requestFinishedCallback;

@property (nonatomic, strong, readonly) id responseObject;
@property (nonatomic, strong, readonly) NSDictionary *responseJSON;

- (GithubRequestMethod)requestMethod;

- (GithubRequestSerializerType)requestSerializerType;

- (NSString *)baseURL;

- (NSString *)requestURL;

- (NSDictionary *)extraHttpHeaders;

- (NSArray *)acceptResponseContentType;

- (NSDictionary *)requestBody;

- (BOOL)isCacheData;

- (BOOL)useCache;

- (void)startWithFinishedBlock:(GithubRequestCallback)finishedBlock;

- (void)pause;

- (void)cancel;

+ (void)setEtag:(NSString *)etag;

+ (NSString *)getEtag;

@end
