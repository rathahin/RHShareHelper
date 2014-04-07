typedef NS_ENUM(NSInteger, ShareHelperResult) {
	ShareHelperResultSuccess,
  ShareHelperResultFailure,
  ShareHelperResultCancel
} ;

typedef NS_ENUM(NSInteger, SocialMedia) {
  SocialMediaFacebook,
  SocialMediaTwitter,
  SocialMediaInstagram,
  SocialMediaEmail
} ;

#import <Foundation/Foundation.h>

@interface ShareHelper : NSObject

@property (nonatomic, strong) NSArray *model;

/*
- (id)initWithShareSource:(id)source optionalDictionary:(NSDictionary *)optionalDictionary;

- (void)presentShareFromController:(UIViewController *)controller
                   socialMediaType:(SocialMedia)socialMediaType
                        completion:(void (^)())completion;
*/

@end
