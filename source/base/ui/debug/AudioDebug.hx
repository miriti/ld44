package base.ui.debug;

import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

class AudioDebug extends GameSprite {
  var state: State;

  var list: Array<TextField> = [];

  public function new(state: State) {
    super();

    this.state = state;
    state.addEventListener('sound_list_update', onSoundListUpdate);
  }
  
  function onSoundListUpdate(e: Event) {
    for(item in list) {
      removeChild(item);
    }

    var ty: Float = 0;
    for(item in state.nowPlaying) {
      var tf: TextField = new TextField();
      tf.text = item.id;
      tf.autoSize = TextFieldAutoSize.LEFT;
      tf.y = ty;
      tf.setTextFormat(new TextFormat('Courier', 6, 0xffffff));
      addChild(tf);
      list.push(tf);
      ty += tf.height;
    }
  }

  override function update(delta: Float) {
  }
}
