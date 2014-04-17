#import "RHShareHelper.h"
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>
#import "RHSharableModel.h"

struct {
  unsigned sharableModelForType : 1;
  unsigned appearenceForNavigationBar : 1;
  unsigned didFinishShareWithType : 1;
  unsigned willShareWithType : 1;
} _delegateHas;

@interface RHShareHelper () <UIActionSheetDelegate, UIDocumentInteractionControllerDelegate, UIAlertViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UIActionSheet     *actionSheet;
@property (nonatomic, strong) UIViewController  *rootViewController;
@property (nonatomic, copy)   void              (^completion)(void);
@property (nonatomic, strong) NSArray           *sharableMedias;
@property (nonatomic, strong) UIDocumentInteractionController *documentController;
@property (nonatomic, assign) SharingType       sharedWithMedia;
@property (nonatomic, assign) BOOL              sharedWithSuccess;
@property (nonatomic, strong) MFMailComposeViewController *mailComposeViewController;

@end

@implementation RHShareHelper

- (id)init {
  
  self = [super init];
  
  if (self) {
    [self commonSetupOnInit];
  }
  
  return self;
  
}

- (void)commonSetupOnInit {
  
  _sharableMedias = @[self.facebook, self.twitter, self.instagram, self.email];
  
}

- (void)setDelegate:(id<RHShareHelperProtocol>)newDelegate {
  
  _delegate = newDelegate;
  
  _delegateHas.sharableModelForType = [_delegate respondsToSelector:@selector(sharableModelForType:)];
  _delegateHas.appearenceForNavigationBar = [_delegate respondsToSelector:@selector(shareHelper:appearenceForNavigationBar:)];
  _delegateHas.didFinishShareWithType = [_delegate respondsToSelector:@selector(shareHelper:didFinishShareWithType:result:)];
  _delegateHas.willShareWithType = [_delegate respondsToSelector:@selector(shareHelper:willShareWithType:)];
  
}

- (RHSharableModel *)shareItemForNetworkType:(SharingType)sharingType {
  
  if (!_delegateHas.didFinishShareWithType) {
    
    [NSException raise:NSInvalidArgumentException format:@"Actor have to implement sharableModelForType method"];
    
  } else {
    
    return [self.delegate sharableModelForType:SharingTypeFacebook];
  
  }
  
  return nil;
  
}

- (void)willShareToNetworkType:(SharingType)sharingType {
  
  if (_delegateHas.sharableModelForType) {
    [self.delegate shareHelper:self willShareWithType:sharingType];
  }
  
}

#pragma mark - API

- (void)shareFromController:(UIViewController *)controller sharingType:(SharingType)sharingType {
  
  self.rootViewController = controller;
  
  switch (sharingType) {
    case SharingTypeFacebook:
      [self shareViaFacebook];
      break;
      
    case SharingTypeTwitter:
      [self shareViaTwitter];
      break;
      
    case SharingTypeInstagram:
      [self shareViaInstagram];
      break;
      
    case SharingTypeEmail:
      [self shareViaMail];
      break;
      
    default:
      break;
  }
}

- (void)presentSheetFromController:(UIViewController *)controller sharableMedias:(NSArray *)sharableMedias {
  self.rootViewController = controller;
  self.sharableMedias = sharableMedias;
  UIActionSheet *sheet = self.actionSheet;
  [sheet showInView:controller.view];
}

#pragma mark - Action Sheet

- (UIActionSheet *)actionSheet {
  
  if (!_actionSheet) {
    _actionSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Share via", nil)
                                               delegate:self
                                      cancelButtonTitle:nil
                                 destructiveButtonTitle:nil
                                      otherButtonTitles:nil];
    
    for (NSDictionary *eachSocialMedia in self.sharableMedias) {
      [_actionSheet addButtonWithTitle:eachSocialMedia[@"title"]];
    }
    
    [_actionSheet setCancelButtonIndex:[_actionSheet addButtonWithTitle:NSLocalizedString(@"Cancel", nil)]];
    
  }
  
  return _actionSheet;
  
}

- (NSDictionary *)facebook {
  if (!_facebook) {
    _facebook = [NSDictionary dictionaryWithObjectsAndKeys:
                 [NSNumber numberWithInt:SharingTypeFacebook], @"service",
                 @"Facebook", @"title",
                 nil];
  }
  
  return _facebook;
}

- (NSDictionary *)twitter {
  if (!_twitter) {
    _twitter = [NSDictionary dictionaryWithObjectsAndKeys:
          [NSNumber numberWithInt:SharingTypeTwitter], @"service",
          @"Twitter", @"title",
    nil];
  }
  
  return _twitter;
}

- (NSDictionary *)instagram {
  
  if (!_instagram) {
    _instagram = [NSDictionary dictionaryWithObjectsAndKeys:
                  [NSNumber numberWithInt:SharingTypeInstagram], @"service",
                  @"Instagram", @"title",
                  nil];
  }
  
  return _instagram;
}

- (NSDictionary *)email {
  if (!_email) {
    _email = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:SharingTypeEmail], @"service",
              @"Email", @"title",
              nil];
  }
  
  return _email;
}

#pragma mark - Twitter

- (void)shareViaTwitter {
  [self willShareToNetworkType:SharingTypeTwitter];
  
  id twitterViewComposer = nil;
  
  if (NSClassFromString(@"UIActivityViewController")) {
    twitterViewComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    if (!twitterViewComposer) {
      return;
    }
    
    ((SLComposeViewController *)twitterViewComposer).completionHandler = ^(SLComposeViewControllerResult result) {
      [self.rootViewController dismissViewControllerAnimated:YES completion:^{
        self.sharedWithMedia = SharingTypeTwitter;
        self.sharedWithSuccess = YES;
        
        if (_delegateHas.didFinishShareWithType) {
          [self.delegate shareHelper:self didFinishShareWithType:self.sharedWithMedia result:ShareHelperResultSuccess];
        }
        
      }];
    };
  }
  
  if (twitterViewComposer) {
    self.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    
    RHSharableModel *shareItem = [self shareItemForNetworkType:SharingTypeFacebook];
    
    if (shareItem.shareText)
      [twitterViewComposer setInitialText:shareItem.shareText];
    
    if (shareItem.shareImage)
      [twitterViewComposer addImage:shareItem.shareImage];
    
    if (shareItem.url) {
      [twitterViewComposer addURL:shareItem.url];
    }
    
    [self.rootViewController presentViewController:twitterViewComposer animated:YES completion:NULL];
    
  }
}

#pragma mark - Facebook

- (void)shareViaFacebook {
  [self willShareToNetworkType:SharingTypeFacebook];
  
  SLComposeViewController *facebookViewComposer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
  
  if (!facebookViewComposer) {
    return;
  }
  
  ((SLComposeViewController *)facebookViewComposer).completionHandler = ^(SLComposeViewControllerResult result) {
    [self.rootViewController dismissViewControllerAnimated:YES completion:^{
      self.sharedWithMedia = SharingTypeFacebook;
      self.sharedWithSuccess = YES;
      
      if (_delegateHas.didFinishShareWithType) {
        [self.delegate shareHelper:self didFinishShareWithType:self.sharedWithMedia result:ShareHelperResultSuccess];
      }
      
    }];
  };
  
  self.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
  
  RHSharableModel *shareItem = [self shareItemForNetworkType:SharingTypeFacebook];
  
  if (shareItem.shareText)
    [facebookViewComposer setInitialText:shareItem.shareText];
  
  if (shareItem.shareImage)
    [facebookViewComposer addImage:shareItem.shareImage];
  
  if (shareItem.url) {
    [facebookViewComposer addURL:shareItem.url];
  }
  
  [self.rootViewController presentViewController:facebookViewComposer animated:YES completion:NULL];
}

#pragma mark - Mail

- (BOOL)canSendMail {
  return [MFMailComposeViewController canSendMail];
}

- (void)shareViaMail {
  
  [self willShareToNetworkType:SharingTypeEmail];
  
  if ([self canSendMail]) {
    
    RHSharableModel *shareItem = [self shareItemForNetworkType:SharingTypeEmail];
    
    self.mailComposeViewController = [[MFMailComposeViewController alloc] init];
    self.mailComposeViewController.mailComposeDelegate = self;
    [self.mailComposeViewController setSubject:shareItem.emailSubject];
    [self.delegate shareHelper:self
    appearenceForNavigationBar:self.mailComposeViewController.navigationBar];
    [self.mailComposeViewController setMessageBody:shareItem.emailBody isHTML:YES];
    [self.rootViewController presentViewController:self.mailComposeViewController animated:YES completion:NULL];
    
  } else {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Device not configured to send mail.", nil)
                                                    message:NSLocalizedString(@"", nil)
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    [alert show];
    
  }
}

#pragma mark - Instagram

- (void)shareViaInstagram {
  
  [self willShareToNetworkType:SharingTypeInstagram];
  
  // no resize, just fire away.
  //UIImageWriteToSavedPhotosAlbum(item.image, nil, nil, nil);
  
  RHSharableModel *shareItem = [self shareItemForNetworkType:SharingTypeInstagram];
  
  UIImage *shareImage = shareItem.shareImage;
  NSString *shareText = shareItem.shareText;
  
  CGFloat cropVal = (shareImage.size.height > shareImage.size.width ? shareImage.size.width : shareImage.size.height);
  
  cropVal *= [shareImage scale];
  
  CGRect cropRect = (CGRect){.size.height = cropVal, .size.width = cropVal};
  CGImageRef imageRef = CGImageCreateWithImageInRect([shareImage CGImage], cropRect);
  
  NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithCGImage:imageRef], 1.0);
  CGImageRelease(imageRef);
  
  NSString *writePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"instagram.igo"];
  
  if (![imageData writeToFile:writePath atomically:YES]) {
    
    if (_delegateHas.didFinishShareWithType) {
      [self.delegate shareHelper:self didFinishShareWithType:SharingTypeInstagram result:ShareHelperResultFailure];
    }
    
  } else {
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
}

#pragma mark -
#pragma mark Action Sheet Delegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  if (buttonIndex == [actionSheet cancelButtonIndex]) {
    
    if (_delegateHas.didFinishShareWithType) {
      [self.delegate shareHelper:self didFinishShareWithType:SharingTypeInstagram result:ShareHelperResultCancel];
    }
    
    return;
  }
  
  int selectedService = [[[self.sharableMedias objectAtIndex:buttonIndex] valueForKey:@"service"] intValue];
  
  switch (selectedService) {
    case SharingTypeFacebook:
      [self shareViaFacebook];
      break;
      
    case SharingTypeTwitter:
      [self shareViaTwitter];
      break;
      
    case SharingTypeInstagram:
      [self shareViaInstagram];
      break;
      
    case SharingTypeEmail:
      [self shareViaMail];
      break;
      
    default:
      break;
  }
}

#pragma mark -
#pragma mark - DocumentController

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
  [self.rootViewController dismissViewControllerAnimated:NO completion:NULL];
  self.sharedWithMedia = SharingTypeInstagram;
  self.sharedWithSuccess = YES;
  
  if (_delegateHas.didFinishShareWithType) {
    [self.delegate shareHelper:self didFinishShareWithType:self.sharedWithMedia result:ShareHelperResultSuccess];
  }
  
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 168) {
    if (buttonIndex == 0) {
      self.sharedWithMedia = SharingTypeInstagram;
      self.sharedWithSuccess = YES;
      
      if (_delegateHas.didFinishShareWithType) {
        [self.delegate shareHelper:self didFinishShareWithType:self.sharedWithMedia result:ShareHelperResultSuccess];
      }
      
    }
  }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
  
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Result: Mail sending canceled");
			break;
		case MessageComposeResultSent:
			NSLog(@"Result: Mail sent");
			break;
		case MessageComposeResultFailed:
			NSLog(@"Result: Mail sending failed");
			break;
		default:
			NSLog(@"Result: Mail not sent");
			break;
	}
  
  [self.mailComposeViewController dismissViewControllerAnimated:YES completion:NULL];
  
  self.sharedWithMedia = SharingTypeEmail;
  self.sharedWithSuccess = YES;
  
  if (_delegateHas.didFinishShareWithType) {
    [self.delegate shareHelper:self didFinishShareWithType:self.sharedWithMedia result:ShareHelperResultSuccess];
  }
  
}

@end
