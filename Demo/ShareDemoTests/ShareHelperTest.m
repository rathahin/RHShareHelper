//
//  ShareHelperTest.m
//  ShareDemo
//
//  Created by Ratha Hin on 4/7/14.
//  Copyright (c) 2014 rathahin. All rights reserved.
//

#import "Kiwi.h"
#import "ShareHelper.h"

SPEC_BEGIN(ShareHelperTest)

describe(@"With share helper", ^{
  
  __block ShareHelper *sharer;
  
  beforeEach(^{
    sharer = [[ShareHelper alloc] init];
  });
  
  context(@"when create new share helper", ^{
    
    it(@"It should exist", ^{
      [sharer shouldNotBeNil];
    });
    
    it(@"The share model should be empty", ^{
      [[sharer.model should] beEmpty];
    });
    
  });
});
SPEC_END
