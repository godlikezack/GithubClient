//
//  GithubRequest.m
//  GitHubClient
//
//  Created by 臧其龙 on 16/5/1.
//  Copyright © 2016年 臧其龙. All rights reserved.
//

#import "GithubRequest.h"
#import "GithubHttpClient.h"

static NSString * const kTokenCode = @"kTokenCode";
static NSString * Etag = @"";

@implementation GithubRequest

- (GithubRequestMethod)requestMethod
{
    return GithubRequestMethodGet;
}

- (GithubRequestSerializerType)requestSerializerType
{
    return GithubRequestSerializerTypeHTTP;
}

- (NSString *)baseURL
{
    return @"";
}

- (NSString *)requestURL
{
    return @"";
}

- (NSDictionary *)extraHttpHeaders
{
    return nil;
}

- (NSArray *)acceptResponseContentType
{
    return nil;
}

- (NSDictionary *)requestBody
{
    return nil;
}

- (void)startWithFinishedBlock:(GithubRequestCallback)finishedBlock
{
    _requestFinishedCallback = finishedBlock;
    [self start];
}

- (void)start{
    [[GithubHttpClient sharedInstance] addRequest:self];
    [self.sessionDataTask resume];
    
}

- (void)pause
{
    [_sessionDataTask suspend];
}

- (void)cancel
{
    [_sessionDataTask cancel];
}

- (void)validateStatus
{
    
}

- (BOOL)isCacheData
{
    return NO;
}

- (BOOL)useCache
{
    return NO;
}

+ (void)setEtag:(NSString *)etag {
    Etag = etag;
}

+ (NSString *)getEtag
{
    return Etag;
}

@end
