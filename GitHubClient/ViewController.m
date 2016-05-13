//
//  ViewController.m
//  GitHubClient
//
//  Created by 臧其龙 on 16/4/30.
//  Copyright © 2016年 臧其龙. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (IBAction)clickLoginBtn:(UIButton *)sender {
    NSString *finalURL = [NSString stringWithFormat:@"https://github.com/login/oauth/authorize?client_id=%@&scope=%@&redirect_uri=%@", kClientID, @"user,repo", kCallbackUrl];
    [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:finalURL]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
