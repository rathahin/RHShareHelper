//
//  SharableModel.h
//  ShareDemo
//
//  Created by Ratha Hin on 4/7/14.
//  Copyright (c) 2014 rathahin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHSharableModel : NSObject

@property (nonatomic, strong) NSString *shareText;
@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *emailBody;
@property (nonatomic, strong) NSString *emailSubject;

@end
