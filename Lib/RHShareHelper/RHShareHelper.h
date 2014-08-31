#import <Foundation/Foundation.h>
#import "RHShareHelperProtocol.h"

typedef NS_ENUM(NSInteger, ShareHelperResult) {
	ShareHelperResultSuccess,
  ShareHelperResultFailure,
  ShareHelperResultCancel
} ;

typedef NS_OPTIONS(NSInteger, SharingType) {
  SharingTypeFacebook,
  SharingTypeTwitter,
  SharingTypeInstagram,
  SharingTypeEmail,
  SharingTypeWhatsapp
} ;

@interface RHShareHelper : NSObject

@property (nonatomic, strong) NSDictionary      *facebook;
@property (nonatomic, strong) NSDictionary      *twitter;
@property (nonatomic, strong) NSDictionary      *instagram;
@property (nonatomic, strong) NSDictionary      *whatsapp;
@property (nonatomic, strong) NSDictionary      *email;
@property (weak, nonatomic) id<RHShareHelperProtocol> delegate;

- (void)shareFromController:(UIViewController *)controller sharingType:(SharingType)sharingType;
- (void)presentSheetFromController:(UIViewController *)controller sharableMedias:(NSArray *)sharableMedias;

@end
