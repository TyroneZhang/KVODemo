#  KVO

## KVO基本用法

### 注册流程
1. 注册观察观察者；
2. 重写观察回调，有四个选项可配置；
3. 释放观察者。

### 添加依赖
如果想要某一些值改变就出发另一个值的观察回调，可以添加依赖。

## KVO底层原理

1. 当注册某个对象的keyPath的观察者时，会动态创建一个NSKVONotifying_TZPerson的类，将当前对象的isa指针指向了新创建的类，如下代码：
``` Objective-C
self.p = [[TZPerson alloc] init];
self.p.name = @"tyrone zhang";

NSLog(@"class name before registing observer: %@", object_getClass(_p ));

[self.p addObserver:self
forKeyPath:@"name"
options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionPrior | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
context:nil];

NSLog(@"class name after registing observer: %@", object_getClass(_p ));
```
上面会输出如下结果：
```
class name before registing observer: TZPerson
class name after registing observer: NSKVONotifying_TZPerson
```
2. 打印两个类的成员变量以及实例方法，可以得到如下结果：
```
class name = TZPerson ----- super class = NSObject
ivars = (
"_name"
)
methods = (
".cxx_destruct",
name,
"setName:"
)

class name = NSKVONotifying_TZPerson ----- super class = TZPerson
ivars = (
)
methods = (
"setName:",
class,
dealloc,
"_isKVOA"
)
```
从打印可以看出，生成的动态类是原类的子类，并且重写了setKey:、class、dealloc方法。
3. setKey方法会调用父类的set方法，给key赋值，通过调用willchange、setkkey、didchange这三个方法来赋值。当付完值后会调用通知observer值改变的方法。
4. 重写class方法是因为不论p的isa指针指向的谁，获取class都应该是其原类TZPerson.
5. 当remove调这个观察者时，会重新将isa指针指向原类。
