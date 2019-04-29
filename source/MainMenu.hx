package;

import openfl.events.MouseEvent;
import base.State;

class MainMenu extends State {
	public function new() {
		super();

		var logo = new Text('LIFE STOCK EXCHANGE', Colors.DARK_BLUE);
		logo.scaleX = logo.scaleY = 2;
		logo.x = (Main.WIDTH - logo.width) / 2;
		logo.y = 8;
		addChild(logo);

		var newGameButton = new Button('PLAY>', Colors.GREEN);
		newGameButton.x = (Main.WIDTH - newGameButton.width) / 2;
		newGameButton.y = (Main.HEIGHT - newGameButton.height) / 2;
		newGameButton.addEventListener(MouseEvent.MOUSE_DOWN, onNewGame);

		addChild(newGameButton);

		var title = new Text('LUDUM DARE #44 BY MICHAEL KEFIR MIRITI', Colors.LIGHT_BLUE);
		title.x = (Main.WIDTH - title.width) / 2;
		title.y = Main.HEIGHT - title.height - 2;
		addChild(title);
	}

	function onNewGame(event:MouseEvent) {
		machine.setState(new Intro());
	}
}
