//
// Created by akuraru on 2014/10/19.
// Copyright (c) 2014 akuraru. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, EitherType) {
    EitherTypeRight,
    EitherTypeLeft,
};

@interface AKUEither : NSObject
@property(readonly, nonatomic) EitherType type;
@property(readonly, nonatomic) id value;

+ (instancetype)t:(EitherType)t v:(id)v;

+ (instancetype)error:(id)v;

- (AKUEither *)map:(AKUEither *(^)(id))f;
@end
