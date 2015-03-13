
# Introduction #

Current ActionScript3 IoC frameworks are quite heavyweight. They try to force you to follow a certain model and make heavy use of reflections. This approach has some problems.

  * Your injected properties are publicly exposed and mutable.
  * `describeType` is very expensive.
  * Steep learning curve.

The Funk IoC container is inspired by [Google Guice](http://google-guice.googlecode.com). Modules declare dependencies for injections with immutable state.

Since ActionScript3 lacks a good annotation system there is only one way to inject objects into a class: `inject(Type)`.

# A Simple Module #

Funk allows you to specify modules and their dependencies in the `configure` method.

```
public final class MyModule extends AbstractModule {
  override protected function configure(): void {
    bind(IInterface).to(InterfaceImpl)
  }
}

public class InterfaceImpl implements IInterface {}

public class MyClass {
  private const _interface: IInterface = inject(IInterface)
}

const module: MyModule = Injector.initialize(MyModule)
const myClass: MyClass = module.getInstance(MyClass)
```

In this example we bound the type `IInterface` to the concrete implementation `InterfaceImpl`. When `MyClass` is instantiated the `inject` function will search for the implementation of `IInterface` in the current module scope. It is obvious that `MyClass` will receive an `InterfaceImpl` instance.

# Provider #

Providers are like factories. You can bind a type to a provider which will instantiate objects the way you specify it.

```
public class MyProvider implements IProvider {
  public function get(): * {
    return new SomeSpecialObject(Math.random())
  }
}

public interface ISpecialProvider extends IProvider {
  // ...
}

public class MySpecialProvider implements ISpecialProvider {
  // ...
}

public class MyModule extends AbstractModule {
  override protected function configure(): void {
    // Use MyProvider to create instances of SomeObject
    bind(SomeObject).toProvider(MyProvider)
    
    // You can bind providers as well!
    bind(ISpecialProvider).to(MySpecialProvider)
    bind(SomeSpecialObject).toProvider(ISpecialProvider)
  }
}
```

# Singletons #

You can specify to use only one instance of an object per module by putting it into the singleton scope. Just call `asSingleton()` for a binding.

```
public class MyModule extends AbstractModule {
  override protected function configure(): void {
    bind(Sprite).asSingleton()
    bind(IAbstract).to(AbstractImpl).asSingleton()
    bind(ISomeProvider).to(SomeProvider).asSingleton()
    bind(IProvided).toProvider(ISomeProvider)
  }
}

public class App {
  private const _root: Sprite = inject(Sprite)
}
```

# Instances #

Instance binding is also possible. Simple use the `toInstance` binding. Instances are automatically scoped as singletons.

```
  override protected function configure(): void {
    bind(String).toInstance("Hello World")
    bind(IAbstract).toInstance(new AbstractInstance)
  }
```

# Give Me My `new` Back! #

With the Funk IoC container you can still use the `new` keyword to instantiate classes. However this works only with keeping two things in mind:

  1. `inject` will search for a module that fits, this costs some speed.
  1. If no binding satisfies the type a `BindingError` is thrown.
  1. If more than one module satisfies the type a `BindingError` is thrown.

Usually it is best practice to use `module.getInstance(Type)` to stay in the scopes you specified.