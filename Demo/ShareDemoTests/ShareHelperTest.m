//
//  ShareHelperTest.m
//  ShareDemo
//
//  Created by Ratha Hin on 4/7/14.
//  Copyright (c) 2014 rathahin. All rights reserved.
//

#import "Kiwi.h"
#import "RHShareHelper.h"

SPEC_BEGIN(ShareHelperTest)

describe(@"With share helper", ^{
  
  __block RHShareHelper *sharer;
  
  beforeEach(^{
    sharer = [[RHShareHelper alloc] init];
  });
  
  context(@"when create new share helper", ^{
    
    it(@"It should exist", ^{
      [sharer shouldNotBeNil];
    });
    
    it(@"Should able to set Delegate", ^{
      [[sharer should] respondToSelector:@selector(setDelegate:)];
    });
    
  });
});

SPEC_END
