# Introduction #

Scala has like other funcitonal languages a great way to define shorthand method closures. This if for instance legal Scala code `List(1,2,3) map (_.toString)`. It will call the toString method on each of the items 1, 2, 3.

Funk allows you to achieve syntax which comes somwhere close to the conciseness of Scala. The same code can be expressed in Funk with `list(1,2,3).map(_.toString)`. The `_` constant will be your best friend if you want to write really short and concise code.

# Predefined #

`_` comes with a set of predefined methods like `_.isEven` or `_.toBoolean`.

```
// Filter all even numbers in [1,100]
Range.to(1, 100).filter(_.isEven)
```

You can also have parameterized methods like `_.incrementBy(x)`.

```
// Increment all values by two
Range.to(1, 5).map(_.incrementBy(2)) //results in list(3, 4, 5, 6, 7)
```

Another option is to use also the predefined get method `_.get(property)`.

```
// Call sprite.x in the mapping
some(new Sprite()).map(_.get('x')) //results in some(0.0)
```

# Implicit #

This is where the fun starts. `_` comes also with implicit definitions for methods and properties. Some cute kittens had to die for this feature but it was worh it. So the Sprite example could be rewritten like this:

```
some(new Sprite()).map(_.x)
```

Another version is to have method calls convert to closures implicitly.

```
class MyClass {
  pulic function funkyStuff(): String { return "funky" }
}

list(new MyClass(), new MyClass()).map(_.funkyStuff()) //results in list("funky", "funky")
```

# Operators #
Sometimes you need an operator for methods like `List.foldLeft`. Those are also defined in the `_` namespace.

```
// Build the sum of all even integers in [1,100]
Range.to(1,100).filter(_.isEven).reduceLeft(_.plus_)
```