//
//  ShareViewController.m
//  ShareDemo
//
//  Created by Ratha Hin on 4/7/14.
//  Copyright (c) 2014 rathahin. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareHelperActor.h"
#import "RHShareHelper.h"

@interface ShareViewController ()

@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *shareToFacebook;
@property (nonatomic, strong) ShareHelperActor *shareActor;
@property (nonatomic, strong) RHShareHelper *shareHelper;

@end

@implementation ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  [self setupShareHelper];
  [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - internal

- (void)setupShareHelper {
  
  ShareHelperActor *shareActor = [[ShareHelperActor alloc] init];
  RHShareHelper *shareHelper = [[RHShareHelper alloc] init];
  shareHelper.delegate = shareActor;
  
  self.shareActor = shareActor;
  self.shareHelper = shareHelper;
  
}

- (void)setupView {
  
  self.view.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.shareButton];
  [self.view addSubview:self.shareToFacebook];
  
}

- (void)showShareAction:(id)sender {
  
  [self.shareHelper presentSheetFromController:self sharableMedias:@[self.shareHelper.facebook,
                                                                     self.shareHelper.twitter,
                                                                     self.shareHelper.email,
                                                                     self.shareHelper.instagram,
                                                                     self.shareHelper.whatsapp]];
  
}

- (void)facebookShareAction:(id)sender {
  [self.shareHelper shareFromController:self sharingType:SharingTypeWhatsapp];
}

#pragma mark - Lazy loading

- (UIButton *)shareButton {
  if (!_shareButton) {
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.frame = CGRectMake(0, 0, 150, 60);
    _shareButton.backgroundColor = [UIColor lightGrayColor];
    [_shareButton setTitle:@"Show Share" forState:UIControlStateNormal];
    _shareButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [_shareButton addTarget:self action:@selector(showShareAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  
  return _shareButton;
}

- (UIButton *)shareToFacebook {
  if (!_shareToFacebook) {
    _shareToFacebook = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareToFacebook.frame = CGRectMake(0, 0, 150, 60);
    _shareToFacebook.backgroundColor = [UIColor lightGrayColor];
    [_shareToFacebook setTitle:@"Whatsapp" forState:UIControlStateNormal];
    _shareToFacebook.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds) / 2);
    [_shareToFacebook addTarget:self action:@selector(facebookShareAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  
  return _shareToFacebook;
}

@end
