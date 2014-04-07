#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ShareHelperResult) {
	ShareHelperResultSuccess,
  ShareHelperResultFailure,
  ShareHelperResultCancel
} ;

typedef NS_OPTIONS(NSInteger, SharingType) {
  SharingTypeFacebook,
  SharingTypeTwitter,
  SharingTypeInstagram,
  SharingTypeEmail
} ;

@class RHSharableModel;
@protocol ShareHelperDelegate, ShareHelperDatasource;

@interface RHShareHelper : NSObject

@property (weak, nonatomic) id<ShareHelperDelegate> delegate;
@property (weak, nonatomic) id<ShareHelperDatasource> datasource;

/*
- (id)initWithShareSource:(id)source optionalDictionary:(NSDictionary *)optionalDictionary;

- (void)presentShareFromController:(UIViewController *)controller
                   socialMediaType:(SocialMedia)socialMediaType
                        completion:(void (^)())completion;
*/

@end



@protocol ShareHelperDelegate <NSObject>

- (void)shareHelper:(RHShareHelper *)shareHelper didFinishWithResult:(ShareHelperResult)restul;

@end

@protocol ShareHelperDatasource <NSObject>

- (RHSharableModel *)sharableModelForType:(SharingType)sharingType;

@end
