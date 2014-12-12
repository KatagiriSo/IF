//
//  main.m
//  IF
//
//  Created by Katagiri11 on 2014/12/13.
//  Copyright (c) 2014年 RodhosSoft. All rights reserved.
//


#import <Foundation/Foundation.h>


@protocol Condition <NSObject>
- (BOOL)calculate;
@end

@protocol Do <NSObject>
- (id<Do>)do;
@end

typedef id<Do>(^DoBlock)(void);

@interface IF : NSObject <Do>
+ (IF*)Condition:(id<Do>)condition Action:(id<Do>)d Else:(id<Do>)e;
- (DoBlock)getDoBlock;
@property (nonatomic) id<Do>Action;
@property (nonatomic) id<Do>Condition;
@property (nonatomic) id<Do>Else;
@end

@implementation IF
+ (IF*)Condition:(id<Do>)condition Action:(id<Do>)d Else:(id<Do>)e;
{
    IF *iif = [IF new];
    iif.Condition = condition;
    iif.Else = e;
    iif.Action = d;
    return iif;
}

- (id<Do>)do
{
    if ([self.Condition do]) {
        return [self.Action do];
    } else {
        return [self.Else do];
    }
    
}

- (DoBlock)getDoBlock
{
    __block id <Do> doObj = self;
    DoBlock doBlock = ^{
        return [doObj do];
    };
    return doBlock;
}
@end


typedef id<Do>(^DoBlock1)(id);
typedef id<Do>(^DoBlock2)(id,id);


@interface Do : NSObject<Do>
@property (nonatomic, copy) DoBlock doblock;
+ b:(DoBlock)doBlock;
@end
@implementation Do
+ b:(DoBlock)doBlock
{
    Do *d = [Do new];
    d.doblock = doBlock;
    return d;
}
- (id <Do>)do
{
    return self.doblock();
}
@end

@interface Do1 : NSObject<Do>
@property (nonatomic, copy) DoBlock1 doblock;
@property (nonatomic) id target;
+ b:(DoBlock1)doBlock target:(id)t;
@end
@implementation Do1
+ b:(DoBlock1)doBlock target:(id)t
{
    Do1 *d = [Do1 new];
    d.doblock = doBlock;
    d.target = t;
    return d;
}
- (id <Do>)do
{
    return self.doblock(self.target);
}
@end

@interface OK : NSObject<Do>
@end
@implementation OK
- (id <Do>)do
{
    return OK.new;
}
@end

@interface NG : NSObject<Do>
@end
@implementation NG
- (id <Do>)do
{
    return NG.new;
}
@end



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        //ex1
        
        int a = -3;
        [[IF Condition:((a>=0) ? OK.new : nil)
                Action:[Do b:^{NSLog(@"a=>0");
            return OK.new;}]
                  Else:[IF Condition:((a<0) ? OK.new : nil)
                              Action:[Do b:^{NSLog(@"a<0");
                      return OK.new;}]
                                Else:NG.new]
          ] do];
        
        IF *iff = [IF Condition:((a>=0) ? OK.new : nil)
                         Action:[Do b:^{NSLog(@"a=>0");return OK.new;}]
                           Else:[IF Condition:((a<0) ? OK.new : nil)
                                       Action:[Do b:^{NSLog(@"a<0");return OK.new;}]
                                         Else:NG.new]
                   ];
        DoBlock doblock = iff.getDoBlock;
        
        doblock();
        
        
        
    }
    return 0;
}
