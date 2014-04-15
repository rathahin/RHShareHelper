RHShareHelper
=============

Implement Sharing to your app even easier.

RHShareHelper is a small library for iOS to share content to social media network. It provice convenience method to present specific network sharing or list of available network to share. It was made to easy implement and set difference content for difference type of network.

##Install with cocoapod
```
platform :ios, "6.0"
pod 'RHShareHelper', '~> 0.0'
```
##Present Sharing

Declare these in class extension

```
@property (nonatomic, strong) ShareHelperActor *shareActor;
@property (nonatomic, strong) RHShareHelper *shareHelper;
```

You will need to provide content to share via ShareHelperActor.

First you should create a method and call from your  ```viewDidLoad``` :

```
- (void)setupShareHelper {
  
  ShareHelperActor *shareActor = [[ShareHelperActor alloc] init];
  RHShareHelper *shareHelper = [[RHShareHelper alloc] init];
  shareHelper.delegate = shareActor;
  
  self.shareActor = shareActor;
  self.shareHelper = shareHelper;
  
}
```

You can present the share options as ActionSheet:

```
  [self.shareHelper presentSheetFromController:self sharableMedias:@[self.shareHelper.facebook,
                                                                     self.shareHelper.twitter,
                                                                     self.shareHelper.email]];
```

or you can present specific network :

```
[self.shareHelper shareFromController:self sharingType:SharingTypeFacebook];
```


##Content to Share
You can set content to share with ShareHelperActor, which delegate for ShareHelper to get content to share after presenting.

```RHSharableModel``` is model object that you need with method ```- (RHSharableModel *)sharableModelForType:(NSInteger)sharingType```

##Why use Actor to set Share Content?

For example, You might want to share Product and App to social network. so you may have difference content for Product sharing and App sharing.

In this case, you can create two actors for them. You can set Actor to ShareHelper when you want to share.

##Todo

- Add custom animation to present Share Options

##License
The MIT License (MIT)

Copyright (c) 2014 nsratha

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.