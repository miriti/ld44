package base.ui;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

class Label extends Sprite {
  public var caption(default, set): String;
  public var color(default, set): Int;

  public var textField: TextField;

  public function new(caption: String, font: String, size: Int, color: Int) {
    super();

    textField = new TextField();
    textField.selectable = false;
    textField.setTextFormat(new TextFormat(font, size));
    textField.autoSize = TextFieldAutoSize.LEFT;
    addChild(textField);

    this.caption = caption;
    this.color = color;
  }

  function set_color(value: Int): Int {
    return color = textField.textColor = value;
  }

  function set_caption(value: String): String {
    return caption = textField.text = value;
  }
}
