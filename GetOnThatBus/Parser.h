//
//  Parser.h
//  GetOnThatBus
//
//  Created by Chris Giersch on 1/20/15.
//  Copyright (c) 2015 ChrisGiersch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootViewController.h"

@protocol ParserDelegate <NSObject>

//@optional
//- (void)fetchAndUnpackJSONDataWithURLString:(NSString *)url;
- (void)fetchDictionaryFromURLString:(NSString *)url;

@end

@interface Parser : NSObject

@property (weak, nonatomic) id<ParserDelegate> delegate;

@end
