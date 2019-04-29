package base;

import openfl.events.Event;

/**
  Fade effect
 **/
class Fade extends GameSprite {
  var type: String;
  var time: Float;
  var callback: Void -> Void;

  public function new(?type: String = 'in', ?time: Float = 1, ?block: Bool = false, ?callback: Void -> Void = null) {
    super();

    this.type = type;
    this.time = time;
    this.callback = callback;

    graphics.beginFill(0x000000);
    graphics.drawRect(0, 0, Main.SCREEN_WIDTH, Main.SCREEN_HEIGHT);
    graphics.endFill();

    if(type == 'in') {
      alpha = 1;
    } else {
      alpha = 0;
    }

    mouseEnabled = block;

    addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
  }

  function done() {
    parent.removeChild(this);
    if(callback != null) {
      callback();
    }
  }

  function onAddedToStage(e: Event) {
    if(type == 'in') {
      tween({ alpha: 0.0 }, time).then(done);
    } else {
      tween({ alpha: 1.0 }, time).then(done);
    }
  }
}
