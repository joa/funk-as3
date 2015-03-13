# Introduction #

Lazy evaluation is a very important feature. You do not want to run an expensive computation more often than you have to. Most of the timme a boolean is used to indicate that something has been evaluated or not. But it is boilerplate code which should be abstracted.

```
private var _evaluated: Boolean = false
private var _value: Number

public function pointlessCalculation(): Number {
  if(_evaluated) {
    return _value
  }

  _evaluated = true;
  _value = Math.sin(Math.PI)
}
```


# Using lazy() #

Funk allows you to abstract this behaviour by using the lazy type. It gaurantees that a function is evaluated only once.

```
const pointless: ILazy = lazy(
  function(): Number {
    return Math.sin(Math.PI)
  }
)

trace(pointless.get)
```

Now this is quite nice but does not make use to the full extent. Imagine using wildcards and closures with the lazy type.

```
// Evaluate Capabilities.serverString lazy
const lazyCapabilities: ILazy = lazy(closure(_.serverString, Capabilities))
```

This example makes a call to `Capabilities.serverString` only once `lazyCapabilities.get` is called. As you can see `closure(_.serverString, Capabilities)` creates a closure which passes `Capabilities` into `_.serverString`. So `closure` replaces `_` with `Capabilities` in this example.

```
// Lazy evaluation with a custom method
const notSoExpensiveAnymore: ILazy = lazy(closure(_.expensiveMethod(1,2,3), expensiveInstance))
```

In this example `notSoExpensiveAnymore.get` will evaluate `expensiveInstance.expensiveMethod(1,2,3)` exactly once. The closure syntax is the same again and replaces the `_` with `expensiveInstance` when it is called.

Note  however that parameters like 1, 2 and 3 from this example are evaluated when you define your lazy computation.