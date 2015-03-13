# Problem #

Current ActionScript3 paradigms lead to code which is very hard to maintain. Besides the usage of the `null` reference is abused as a place holder for "Your request did not succeed."

For example the simple method `firstChild` of a DisplayObject could be defined like this

```
function get firstChild(): DisplayObject {
  return getChildAt(0)
}
```

Now what is the problem? Obviously `firstChild` results in a RangeError if the DisplayObjectContainer has no children. So how can we express it? We could add a @throws annotation to the `firstChild` method. But who is going to read that?

Another option is to return `null` when no child exists. This would result in `null` reference errors all over the place probably. Now you might think that another solution is to return a new DisplayObject if none exists. But first of all that DisplayObjectis not a child of the parent and second if you make it a child your `firstChild` method becomes stateful. This is evil. Imagine trace(sprite.x) would move a Sprite some pixels to the right because the getter for `x` changes the state of the Sprite object. An implicit getter should never change the state of its object.


# Solution #

The Option type fills the gap of the need to express that a computation can also fail in the sense that it does not return any valuable information. Funk gives you two utilities to express this. `some()` and `none` which are both of type `IOption`.

So how would our `firstChild` method look like using the `IOption` type?

```
function get firstChild(): IOption/*.<DisplayObject>*/ {
  return numChildren == 0 ? none : some(getChildAt(0))
}
```

So what happens now when you would call `firstChild` on an empty DisplayObjectContainer? You would receive `none`. But if a child is available you will receive it. You are now also force to handle the case of an undefined result.

```
const displayObject: IOption = displayObjectContainer.firstChild
if(displayObject.isDefined) {
  trace(displayObject.get.x)
}
```

This code is however still not very nice. You do not want to write if-then-else all the time. This is why the option type comes with some utility methods to map over it for instance. If we would have generics and typed function closures the map function would be defined like this `IOption.<A>.map(A => B): IOption.<B>`.

So in plain english, if you want to get the `x` value like in the example above you can simply map to it.

```
const displayObject: IOption = displayObjectContainer.firstChild
trace(displayObject.map(_.x).getOrElse(pass.number(NaN))
```

So what is `map(_.x)` doing? If the option is defined, its value will be mapped using the wildcard `_.x`. Then `getOrElse` will return either the mapped value or a default value in case of a non existing first child.

`pass.number(NaN)` creates a function that returns `NaN` when called.