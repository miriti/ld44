package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;

class Button extends Sprite {
	var theButton:Sprite;
	var normalBackground:Sprite = new Sprite();
	var activeBackground:Sprite = new Sprite();

	public var active(default, set):Bool;

	function set_active(value:Bool):Bool {
		active = value;

		normalBackground.visible = !active;
		activeBackground.visible = active;

		return active;
	}

	public function new(title:String, bgcolor:Int, activeColor:Int = 0xf0d472, btnWidth:Int = 60, btnHeight:Int = 15, textcolor:Int = 0xf9f5ef) {
		super();

		buttonMode = true;

		graphics.beginFill(0x47416b);
		graphics.drawRect(1, 1, btnWidth, btnHeight);

		theButton = new Sprite();

		normalBackground.graphics.beginFill(bgcolor);
		normalBackground.graphics.drawRect(0, 0, btnWidth, btnHeight);
		normalBackground.graphics.endFill();

		activeBackground.graphics.beginFill(activeColor);
		activeBackground.graphics.drawRect(0, 0, btnWidth, btnHeight);
		activeBackground.graphics.endFill();

		active = false;

		theButton.addChild(normalBackground);
		theButton.addChild(activeBackground);

		var text = new Text(title, textcolor);
		text.x = Math.floor((theButton.width - text.width) / 2);
		text.y = Math.floor((theButton.height - text.height) / 2);
		theButton.addChild(text);

		addChild(theButton);

		addEventListener(MouseEvent.MOUSE_DOWN, onMouseButton);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}

	function onMouseButton(e:MouseEvent) {
		theButton.x = theButton.y = 1;
	}

	function onMouseUp(e:MouseEvent) {
		theButton.x = theButton.y = 0;
	}
}
