# Introduction #

This example shows you some basic techniques and how Funk allows you to write functional code. The example adds four sprites to the stage which display a rectangle.


# Code #
```
package flashx.funk.example {
  import flash.display.Graphics
  import flash.display.Sprite

  import flashx.funk._
  import flashx.funk.collections.IList
  import flashx.funk.collections.immutable.List
  import flashx.funk.pass
  import flashx.funk.tuple.ITuple2

  public final class SpriteExample extends Sprite {
    public function SpriteExample() {
      // Create a list of 4 sprite instances.
      const sprites: IList = List.fill(4)(pass.instanceOf(Sprite))

      // Map the sprites to their graphics object and apply a
      // function on each of them.
      sprites.map(_.graphics).foreach(function(g: Graphics): void {
        g.beginFill(0x33ccff)
        g.drawRect(0.0, 0.0, 16.0, 16.0)
        g.endFill()
      })

      // Combine the Sprite objects with their index, resulting
      // in a IList.<ITuple2.<Sprite, int>> (pseudocode!)
      //
      // Apply a function on each tuple in order to position the
      // sprite based on its index in the list.
      sprites.zipWithIndex.foreach(function(element: ITuple2): void {
        const sprite: Sprite = element._1
        const index: Number = element._2

        sprite.x = sprite.y = index * 32.0
      })

      // Add all sprites to the display list
      sprites.foreach(addChild)
    }
  }
}
```
## Alternative ##
You achieve the same effect with less code of course as well.
```
Range.until(0, 4).foreach(function(i: int): void {
  const sprite: Sprite = new Sprite

   with(sprite) {
    with(graphics) {
      beginFill(0x33ccff)
      drawRect(0.0, 0.0, 16.0, 16.0)
      endFill()
    }
    x = y = i * 32.0
  }

  addChild(sprite)
})
```