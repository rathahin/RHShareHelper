//
//  RHShareHelperProtocol.h
//  ShareDemo
//
//  Created by Ratha Hin on 4/8/14.
//  Copyright (c) 2014 rathahin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RHSharableModel, RHShareHelper;
@protocol RHShareHelperProtocol <NSObject>

- (void)shareHelper:(RHShareHelper *)shareHelper
didFinishShareWithType:(NSInteger)sharingType
             result:(NSInteger)result;

- (void)shareHelper:(RHShareHelper *)shareHelper appearenceForNavigationBar:(UINavigationBar *)navigationBar;

- (RHSharableModel *)sharableModelForType:(NSInteger)sharingType;

@end
