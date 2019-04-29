package base;

typedef EasingFunc = Float -> Float;

/**
 * Tween Class
 */
class Tween {
  var time: Float;
  var time_passed: Float = 0;

  var properties: Dynamic;

  var init: Dynamic = {};
  var target: GameSprite;

  var easeFunc: EasingFunc;

  var callback: Void -> Void = null;

  var steps: Int = 0;

  /**
   * Constructor
   */
  public function new(target: GameSprite, time: Float, properties: Dynamic) {
    this.time = time;
    this.properties = properties;
    this.target = target;

    easeFunc = Tween.linear;

    for(f in Reflect.fields(properties)) {
      Reflect.setField(init, f, Reflect.getProperty(target, f));
    }
  }

  public function easing(func: EasingFunc) {
    easeFunc = func;
    return this;
  }

  public function then(callback: Void -> Void) {
    this.callback = callback;
    return this;
  }

  /**
   * Update tween
   */
  public function update(delta: Float) {
    for(f in Reflect.fields(init)) {
      var b: Float = Reflect.field(init, f);
      var c: Float = Reflect.field(properties, f);
      var offset = time_passed / time;
      var result = b + (c - b) * easeFunc(offset);
      Reflect.setProperty(target, f, result);
    }

    if(time_passed < time) {
      time_passed = Math.min(time, time_passed + delta);
      return this;
    } else {
      if(callback != null) {
        callback();
      }
    }

    return null;
  }

  /**
   * Linear interpolation
   */
  public static function linear(k: Float): Float {
    return k;
  }

  /**
   * Sine interpolation
   */
  public static function sine(k: Float): Float {
    return 1 - Math.cos(k * (Math.PI / 2));
  }

  public static function quadIn(k: Float): Float {
    return k * k;
  }

  public static function quadOut(k: Float): Float {
    return -k * (k - 2);
  }

  public static function cube(k: Float): Float {
    return k * k * k;
  }
}
