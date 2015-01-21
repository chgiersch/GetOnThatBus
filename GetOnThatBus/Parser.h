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

- (void)requestDidFinishWithArray:(NSMutableArray *)array;

@end

@interface Parser : NSObject

- (void)requestDictionaryWithURLString:(NSString *)urlString;
- (void)unpackDictionariesFromArray:(NSMutableArray *)array;

@property (weak, nonatomic) id<ParserDelegate> delegate;

@end