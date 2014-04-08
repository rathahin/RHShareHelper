//
//  ShareHelperActor.m
//  ShareDemo
//
//  Created by Ratha Hin on 4/8/14.
//  Copyright (c) 2014 rathahin. All rights reserved.
//

#import "ShareHelperActor.h"
#import "RHSharableModel.h"
#import "RHShareHelper.h"

@implementation ShareHelperActor

- (RHSharableModel *)sharableModelForType:(NSInteger)sharingType {
  
  RHSharableModel *shareItem = [RHSharableModel new];
  
  if (sharingType != SharingTypeEmail) {
    
    shareItem.shareText = @"Up comming WWDC!";
    shareItem.url = [NSURL URLWithString:@"https://developer.apple.com/wwdc/"];
    
  } else {
    
    shareItem.emailSubject = @"Up comming WWDC!";
    shareItem.emailBody = @"Checkout up comming WWDC at https://developer.apple.com/wwdc/";
    
  }
  
  return shareItem;
}

- (void)shareHelper:(RHShareHelper *)shareHelper appearenceForNavigationBar:(UINavigationBar *)navigationBar {
  
  [navigationBar setTintColor:[UIColor darkGrayColor]];
  NSShadow *shadow = [NSShadow new];
  shadow.shadowColor = [UIColor blackColor];
  shadow.shadowOffset = CGSizeMake(0, -1);
  NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                             [UIColor darkGrayColor],
                                             NSForegroundColorAttributeName,
                                             shadow,
                                             NSShadowAttributeName,
                                             [UIFont fontWithName:@"HelveticaNeue" size:17.0f],
                                             NSFontAttributeName,
                                             nil];
  
  [navigationBar setTitleTextAttributes:navbarTitleTextAttributes];
  
}

- (void)shareHelper:(RHShareHelper *)shareHelper didFinishShareWithType:(NSInteger)sharingType result:(NSInteger)result {
  
  // Required by protocol
  
}

@end
