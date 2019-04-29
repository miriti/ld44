package base;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;

/**
  Scrolling image
 **/
class Scrolling extends GameSprite {
  public var scrollX(default, set): Float;
  public var scrollVelocity: Point = new Point();

  /**
    SET scrollX
   **/
  function set_scrollX(value: Float): Float {
    if(value > samples[0].width) {
      value = value - samples[0].width;
    }

    if(value < 0) {
      value = samples[0].width + value; // maybe..
    }

    for(i in 0...samples.length) {
      samples[i].x = (i * samples[0].width) - value;
    }

    return scrollX = value;
  }

  private var samples: Array<Bitmap> = [];

  /**
    Constructor
   **/
  public function new(bitmapData: BitmapData, samplesNumber: Int = 2) {
    super();

    for(i in 0...samplesNumber) {
      var newBitmap = new Bitmap(bitmapData);
      samples.push(newBitmap);
      addChild(newBitmap);
    }

    scrollX = 0;
  }

  override public function update(delta: Float) {
    scrollX += scrollVelocity.x * delta;
    super.update(delta);
  }
}
