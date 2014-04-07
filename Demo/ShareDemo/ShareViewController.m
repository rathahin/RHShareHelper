//
//  ShareViewController.m
//  ShareDemo
//
//  Created by Ratha Hin on 4/7/14.
//  Copyright (c) 2014 rathahin. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@property (nonatomic, strong) UIButton *shareButton;

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
  [self setupView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - internal

- (void)setupView {
  
  self.view.backgroundColor = [UIColor darkGrayColor];
  [self.view addSubview:self.shareButton];
  
}

- (void)showShareAction:(id)sender {
  
  
  
}

#pragma mark - Lazy loading

- (UIButton *)shareButton {
  if (!_shareButton) {
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.frame = CGRectMake(0, 0, 150, 60);
    _shareButton.backgroundColor = [UIColor redColor];
    [_shareButton setTitle:@"Show Share" forState:UIControlStateNormal];
    _shareButton.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [_shareButton addTarget:self action:@selector(showShareAction:) forControlEvents:UIControlEventTouchUpInside];
  }
  
  return _shareButton;
}

@end
