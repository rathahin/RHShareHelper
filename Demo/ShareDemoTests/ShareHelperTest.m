//
//  ShareHelperTest.m
//  ShareDemo
//
//  Created by Ratha Hin on 4/7/14.
//  Copyright (c) 2014 rathahin. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(ShareHelperTest)

describe(@"In our first Kiwi test", ^{
  context(@"a sample string", ^{
    NSString *greeting = @"Hello, World";
    
    it(@"should exist", ^{
      [greeting shouldNotBeNil];
    });
    
    it(@"should be 'Hello, World'", ^{
      [[greeting should] equal:@"Hello, World"];
    });
    
  });
});
SPEC_END
