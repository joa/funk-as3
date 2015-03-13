
```
"HELLO WORLD" == toList("dlrow olleh").map(_.toUpperCase).reduceRight(_.plus_)
```

# Introduction #

The Funk library supports functional development in ActionScript3. Some of its key features are:

  * Utilities to avoid boilerplate code
    * Currying
    * Lazy evaluation
    * Closure wrapping
    * Continuations (Not to confuse with continuation-passing style)
  * Immutable collections
  * Option type
  * Tuple type
  * IoC Container (no reflections, no Metadata and immutable!)

Using Funk will result in a performance loss. But your code will be more conciese and contain less boilerplate. Use this library if you want elegant code in applications that are not performance critical. Funk enforces immutable state and the avoidance of `null` which will prevent you from common mistakes.

# Examples #
## IoC with Funk ##
```
class NetworkModule extends AbstractModule {
  override protected function configure(): void {
    bind(String).toInstance("127.0.0.1")
    bind(int).toInstance(8080)
    bind(IRequestQueue).to(SomeRequestQueue).asSingleton()
    bind(IRequestDispatcher).toProvider(IRequestDispatcherProvider)
    bind(IRequestDispatcherProvider).to(SomeRequestDispatcherProvider)
    bind(Headers).asSingleton()
  }
}

class SomeRequestDispatcherProvider implements IProvider {
  public function get(): * { return new RequestDispatcher }
}

class RequestDispatcher implements IRequestDispatcher {
  private const _queue: IRequestQueue = inject(IRequestQueue)
  private const _headers: Headers = inject(Headers)
  private const _host: String = inject(String)
  private const _port: int = inject(int)
  // ...
}

class Whatever {
  private const _dispatcher: IRequestDispatcher = inject(IRequestDispatcher)
  // ...
}
const network: IModule = Injector.initialize(new NetworkModule)
const whatever: Whatever = network.getInstance(Whatever)
const thisWorksToo: Whatever = new Whatever()
```
## Continuations ##
```
var file: IFile = ...
var deleteButton: SimpleButton = new SimpleButton(...)

deleteButton.addEventListener(Event.CLICK,
  fork(
    Dialog.show(this, ["Do you want to delete your file?", Dialog.YES | Dialog.NO])
  ).andContinue(
   function(confirmed: Boolean): void {
      if(confirmed) {
        file.delete()
      }
    }
  )
)
```
## Currying ##
```
var modulo: Function = function(n: int, x: int): int { return x % n }
var mod3: Function = curry(modulo, 3)
trace(7 % 3, modulo(3, 7), mod3(7))
```
## Using the option type ##
```
class User {
  public var name: String
}

function getUser(name: String): IOption/*.<IUser>*/ {
  if(containsUserWithName(name)) {
    return some(users[name])
  } else {
    return none
  }
}

getUser("kermit").map(_.name).getOrElse(pass.string("Unknown User"))
```