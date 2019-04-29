package;

import openfl.events.MouseEvent;
import base.GameSprite;

class DialogBox extends GameSprite {
	public function new(message:String, callback:Void->Void, dlgWidth:Int = 160, dlgHeight:Int = 60) {
		super();

		graphics.beginFill(Colors.DARK_BLUE);
		graphics.drawRect(1, 1, dlgWidth, dlgHeight);
		graphics.endFill();

		graphics.beginFill(Colors.WHITE);
		graphics.lineStyle(1.0, Colors.DARK_BLUE);
		graphics.drawRect(0, 0, dlgWidth, dlgHeight);
		graphics.endFill();

		var textContainer = new GameSprite();

		var nextY:Float = 0.0;

		for (str in message.split('\n')) {
			var text:Text = new Text(str, Colors.DARK_BLUE);
			text.x = -text.width / 2;
			text.y = nextY;
			textContainer.addChild(text);
			nextY += text.height + 2;
		}

		var okButton = new Button('OK', Colors.GREEN);
		okButton.x = (dlgWidth - okButton.width) / 2;
		okButton.y = (dlgHeight - okButton.height - 2);
		okButton.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent) {
			parent.removeChild(this);
			callback();
		});
		addChild(okButton);

		textContainer.x = dlgWidth / 2;
		textContainer.y = (dlgHeight - okButton.height - 4 - textContainer.height) / 2;
		addChild(textContainer);
	}
}
