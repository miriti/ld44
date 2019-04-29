package base.ui;

import openfl.text.TextFieldType;

class Input extends Label {
  public function new(defaultValue: String, font: String, size: Int, color: Int) {
    super(defaultValue, font, size, color);
    textField.type = TextFieldType.INPUT;
    textField.selectable = true;
  }
}
