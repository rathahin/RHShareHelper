#import "ShareHelper.h"
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>

@interface ShareHelper () <UIActionSheetDelegate, UIDocumentInteractionControllerDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) NSDictionary      *facebook;
@property (nonatomic, strong) NSDictionary      *twitter;
@property (nonatomic, strong) NSDictionary      *instagram;
@property (nonatomic, strong) UIViewController  *rootViewController;
@property (nonatomic, copy)   void              (^completion)(void);
@property (nonatomic, strong) NSArray           *socialMedias;
@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@property (nonatomic, assign) SocialMedia       sharedWithMedia;
@property (nonatomic, assign) BOOL              sharedWithSuccess;
@property (nonatomic, strong) id source;
@property (nonatomic, strong) MFMailComposeViewController *mailComposeViewController;

@end

@implementation ShareHelper



/*
- (id)initWithShareSource:(id)source optionalDictionary:(NSDictionary *)optionalDictionary {
  self = [super init];
  
  if (self) {
    NSString *shareString = nil;
    NSArray *socialMedias = nil;
    NSURL *shareURL = nil;
    
    if ([source isKindOfClass:[VGEvent class]]) {
      shareString = [NSString stringWithFormat:NSLocalizedString(@"shareBody", @""), [source title]];
      shareURL = [source detailURL];
      socialMedias = @[self.facebook, self.twitter, self.instagram];
    }
    
    BShareableItem *item = [[BShareableItem alloc] initWithShareText:shareString];
    
    item.shareImage = nil;
    item.url = shareURL;
    
    self.shareItem = item;
    
    self.source = source;
  }
  
  return self;
}

- (void)trackAndCallback {
  
  if (self.completion) {
    self.completion();
  }
}

- (void)presentShareFromController:(UIViewController *)controller socialMediaType:(SocialMedia)socialMediaType completion:(void (^)())completion {
  self.rootViewController = controller;
  self.completion = completion;
  
  switch (socialMediaType) {
    case SocialMediaFacebook:
      [self shareViaFacebook];
      break;
      
    case SocialMediaTwitter:
      [self shareViaTwitter];
      break;
      
    case SocialMediaInstagram:
      [self shareViaInstagram];
      break;
      
    case SocialMediaEmail:
      [self shareViaMail];
      break;
      
    default:
      break;
  }
}

#pragma mark -
#pragma mark - Action Sheet

- (UIActionSheet *)sheetForSharing:(BShareableItem *)item viaSocialMedia:(NSArray *)socialMedias completion:(void (^)(ShareHelperResult))completionBlock {
  self.socialMedias = socialMedias;
  self.shareItem = item;
  self.sharedWithSuccess = NO;
  
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Share via"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:nil];
  
  for (NSDictionary *eachSocialMedia in socialMedias) {
    [sheet addButtonWithTitle:eachSocialMedia[@"title"]];
  }
  
  [sheet setCancelButtonIndex:[sheet addButtonWithTitle:@"Cancel"]];
  
  return sheet;
}

- (NSDictionary *)facebook {
  return [NSDictionary dictionaryWithObjectsAndKeys:
          [NSNumber numberWithInt:SocialMediaFacebook], @"service",
          @"Facebook", @"title",
          nil];
}

- (NSDictionary *)twitter {
  return [NSDictionary dictionaryWithObjectsAndKeys:
          [NSNumber numberWithInt:SocialMediaTwitter], @"service",
          @"Twitter", @"title",
          nil];
}

- (NSDictionary *)instagram {
  return [NSDictionary dictionaryWithObjectsAndKeys:
          [NSNumber numberWithInt:SocialMediaInstagram], @"service",
          @"Instagram", @"title",
          nil];
}

#pragma mark - Twitter

- (void)shareViaTwitter {
  id twitterViewComposer = nil;
  
  if (NSClassFromString(@"UIActivityViewController")) {
    twitterViewComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    if (!twitterViewComposer) {
      return;
    }
    
    ((SLComposeViewController *)twitterViewComposer).completionHandler = ^(SLComposeViewControllerResult result) {
      [self.rootViewController dismissViewControllerAnimated:YES completion:^{
        self.sharedWithMedia = SocialMediaTwitter;
        self.sharedWithSuccess = YES;
        [self trackAndCallback];
      }];
    };
  }
  
  if (twitterViewComposer) {
    self.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    NSLog(@"Share body to Twitter %@", NSLocalizedString(@"message.shareBodyTwitter", nil));
    
    if (self.shareItem.shareText)
      [twitterViewComposer setInitialText:[NSString stringWithFormat:NSLocalizedString(@"message.shareBodyTwitter", nil), [(VGEvent *)self.source title]]];
    
    if (self.shareItem.shareImage)
      [twitterViewComposer addImage:self.shareItem.shareImage];
    
    if (self.shareItem.url) {
      [twitterViewComposer addURL:self.shareItem.url];
    }
    
    [self.rootViewController presentViewController:twitterViewComposer animated:YES completion:NULL];
  }
}

#pragma mark - Facebook

- (void)shareViaFacebook {
  SLComposeViewController *facebookViewComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
  
  if (!facebookViewComposer) {
    return;
  }
  
  ((SLComposeViewController *)facebookViewComposer).completionHandler = ^(SLComposeViewControllerResult result) {
    [self.rootViewController dismissViewControllerAnimated:YES completion:^{
      self.sharedWithMedia = SocialMediaFacebook;
      self.sharedWithSuccess = YES;
      [self trackAndCallback];
    }];
  };
  
  self.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
  
  if (self.shareItem.shareText)
    [facebookViewComposer setInitialText:[NSString stringWithFormat:NSLocalizedString(@"message.shareBodyFacebook", nil), [(VGEvent *)self.source title]]];
  
  if (self.shareItem.shareImage)
    [facebookViewComposer addImage:self.shareItem.shareImage];
  
  if (self.shareItem.url) {
    [facebookViewComposer addURL:self.shareItem.url];
  }
  
  [self.rootViewController presentViewController:facebookViewComposer animated:YES completion:NULL];
}

#pragma mark - Mail

- (BOOL)canSendMail {
  return [MFMailComposeViewController canSendMail];
}

- (void)shareViaMail {
  if ([self canSendMail]) {
    self.mailComposeViewController = [[MFMailComposeViewController alloc] init];
    self.mailComposeViewController.mailComposeDelegate = self;
    [self.mailComposeViewController setSubject:[NSString stringWithFormat:NSLocalizedString(@"emailTitle", nil), [(VGEvent *)self.source title]]];
    [self.mailComposeViewController.navigationBar setTintColor:[VegasTheme yellowColor]];
    [self.mailComposeViewController.navigationBar setBarStyle:UIBarStyleBlack];
    [self.mailComposeViewController.navigationBar setTranslucent:NO];
   
    CGFloat iOSVersion = [[[UIDevice currentDevice] systemVersion] floatValue];

    if (iOSVersion < 7.0) {
      [self.mailComposeViewController.navigationBar setTintColor:[VegasTheme blackColor]];
      [self.mailComposeViewController.navigationBar setBackgroundColor:[VegasTheme yellowColor]];
    }else{
      [self.mailComposeViewController.navigationBar setBackgroundColor:[VegasTheme yellowColor]];
      #if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
      [self.mailComposeViewController.navigationBar setBarTintColor:[VegasTheme blackColor]];
      #endif
    }
    
    [self.mailComposeViewController setMessageBody:[NSString stringWithFormat:NSLocalizedString(@"emailBody", nil), [self.source title], [self.source detailURL]] isHTML:YES];
    [self.rootViewController presentViewController:self.mailComposeViewController animated:YES completion:NULL];
  } else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"mailErrorTitle", nil)
                                                    message:NSLocalizedString(@"mailErrorMessage", nil)
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ui.OK", nil)
                                          otherButtonTitles:nil];
    [alert show];
  }
}

#pragma mark - Instagram

- (void)shareViaInstagram {
  // no resize, just fire away.
  //UIImageWriteToSavedPhotosAlbum(item.image, nil, nil, nil);
  
  UIImage *shareImage = self.shareItem.shareImage;
  NSString *shareText = self.shareItem.shareText;
  
  CGFloat cropVal = (shareImage.size.height > shareImage.size.width ? shareImage.size.width : shareImage.size.height);
  
  cropVal *= [shareImage scale];
  
  CGRect cropRect = (CGRect){.size.height = cropVal, .size.width = cropVal};
  CGImageRef imageRef = CGImageCreateWithImageInRect([shareImage CGImage], cropRect);
  
  NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithCGImage:imageRef], 1.0);
  CGImageRelease(imageRef);
  
  NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
  
  if (![imageData writeToFile:writePath atomically:YES]) {
    // failure
    DDLogWarn(@"image save failed to path %@", writePath);
    [self trackAndCallback];
    return;
  } else {
    // success.
  }
  
  // send it to instagram.
  NSURL *fileURL = [NSURL fileURLWithPath:writePath];
  self.documentController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
  self.documentController.delegate = self;
  [self.documentController setUTI:@"com.instagram.exclusivegram"];
  
  if (shareText) {
    [self.documentController setAnnotation:@{@"InstagramCaption" : shareText}];
  }
  
  if (![self.documentController presentOpenInMenuFromRect:CGRectZero inView:self.rootViewController.view animated:YES]) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"openInstagramFailedTitle"
                                                        message:@"openInstagramFailedMessage"
                                                       delegate:self
                                              cancelButtonTitle:@"ok"
                                              otherButtonTitles:nil];
    alertView.tag = 168;
    [alertView show];
  }
}

#pragma mark -
#pragma mark Action Sheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  if (buttonIndex == [actionSheet cancelButtonIndex]) {
    [self trackAndCallback];
    return;
  }
  
  int selectedService = [[[self.socialMedias objectAtIndex:buttonIndex] valueForKey:@"service"] intValue];
  
  switch (selectedService) {
    case SocialMediaFacebook:
      [self shareViaFacebook];
      break;
      
    case SocialMediaTwitter:
      [self shareViaTwitter];
      break;
      
    case SocialMediaInstagram:
      [self shareViaInstagram];
      break;
      
    default:
      break;
  }
}

#pragma mark -
#pragma mark - DocumentController

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
  [self.rootViewController dismissViewControllerAnimated:NO completion:NULL];
  self.sharedWithMedia = SocialMediaInstagram;
  self.sharedWithSuccess = YES;
  [self trackAndCallback];
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 168) {
    if (buttonIndex == 0) {
      self.sharedWithMedia = SocialMediaInstagram;
      self.sharedWithSuccess = YES;
      [self trackAndCallback];
    }
  }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
  
	switch (result) {
		case MessageComposeResultCancelled:
			DDLogVerbose(@"Result: Mail sending canceled");
			break;
		case MessageComposeResultSent:
			DDLogVerbose(@"Result: Mail sent");
			break;
		case MessageComposeResultFailed:
			DDLogVerbose(@"Result: Mail sending failed");
			break;
		default:
			DDLogVerbose(@"Result: Mail not sent");
			break;
	}
  
  [self.mailComposeViewController dismissViewControllerAnimated:YES completion:NULL];
  
  self.sharedWithMedia = SocialMediaEmail;
  self.sharedWithSuccess = YES;
  [self trackAndCallback];
}
*/
@end
