//
// Created by akuraru on 2014/10/19.
// Copyright (c) 2014 akuraru. All rights reserved.
//

#import "AKUEither.h"
@implementation AKUEither {}
+ (instancetype)t:(EitherType)t v:(id)v {
    return [[AKUEither alloc] initWithEither:t v:v];
}

+ (instancetype)error:(id)v {
    return [self t:v ? EitherTypeLeft : EitherTypeRight v:v];
}

- (instancetype)initWithEither:(EitherType)t v:(id)v {
    self = [super init];
    if (self) {
        _type = t;
        _value = v;
    }
    return self;
}

- (AKUEither *)map:(AKUEither *(^)(id))f {
    if (self.type == EitherTypeLeft) {
        return self;
    } else {
        return f(self.value);
    }
}
@end
