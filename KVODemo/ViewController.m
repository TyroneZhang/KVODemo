//
//  ViewController.m
//  KVODemo
//
//  Created by Demon_Yao on 2019/5/30.
//  Copyright © 2019 Tyrone Zhang. All rights reserved.
//

#import "ViewController.h"
#import "TZPerson.h"
#import <Objc/runtime.h>

@interface ViewController ()

@property (nonatomic, strong) TZPerson *p;

@end

@implementation ViewController

- (void)dealloc {
    [self.p removeObserver:self forKeyPath:@"name" context:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.p = [[TZPerson alloc] init];
    self.p.name = @"tyrone zhang";
    
    Class priClass = object_getClass(_p);
    NSLog(@"class name before registing observer: %@", priClass);
    [self printClass: priClass];
    
    [self.p addObserver:self
             forKeyPath:@"name"
                options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                context:nil];
    
    Class kvoClass = object_getClass(_p);
    NSLog(@"class name after registing observer: %@", kvoClass);
    [self printClass:kvoClass];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"change = %@", change);
}

- (void)printClass:(Class)class {
    const char * name = object_getClassName(class);
    NSLog(@"class name = %s ----- super class = %@", name, class_getSuperclass(class));
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList(class, &outCount);
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        const char * ivarName = ivar_getName(ivar);
        [arr addObject:[NSString stringWithCString:ivarName encoding:NSUTF8StringEncoding]];
    }
    NSLog(@"ivars = %@", arr);
    
    Method *methods = class_copyMethodList(class, &outCount);
    NSMutableArray *arr2 = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        SEL sel = method_getName(method);
        [arr2 addObject:[NSString stringWithCString:sel_getName(sel) encoding:NSUTF8StringEncoding]];
    }
    NSLog(@"methods = %@", arr2);
    
}


@end
