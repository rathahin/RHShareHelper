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
  
  if (sharingType == SharingTypeEmail) {
    
    shareItem.emailSubject = @"Up comming WWDC!";
    shareItem.emailBody = @"Checkout up comming WWDC at https://developer.apple.com/wwdc/";
    
  } else if (sharingType == SharingTypeInstagram) {
    
    shareItem.shareText = @"Love low poly style";
    shareItem.shareImage = [UIImage imageNamed:@"photo"];
  
  } else {
    
    shareItem.shareText = @"Up comming WWDC!";
    shareItem.url = [NSURL URLWithString:@"https://developer.apple.com/wwdc/"];
    
  }
  
  //photo
  
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
  
  NSLog(@"did share with %@", [self networkNameWithEnumType:sharingType]);
  
}

- (void)shareHelper:(RHShareHelper *)shareHelper willShareWithType:(NSInteger)sharingType {
  
  NSLog(@"will share with %@", [self networkNameWithEnumType:sharingType]);
  
}

- (NSString *)networkNameWithEnumType:(SharingType)sharingType {
  
  NSString *result;
  
  switch (sharingType) {
    case SharingTypeFacebook:
      result = @"Facebook";
      break;
      
    case SharingTypeEmail:
      result = @"Email";
      break;
      
    case SharingTypeInstagram:
      result = @"Instagram";
      break;
      
    case SharingTypeTwitter:
      result = @"Twitter";
      break;
      
    default:
      break;
  }
  
  return result;
  
}

@end
