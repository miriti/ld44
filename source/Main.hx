package;

import base.StateMachine;

class Main extends StateMachine {
	public static inline var WIDTH:Float = 256;
	public static inline var HEIGHT:Float = 190;

	public function new() {
		super();

		scaleX = scaleY = 3;

		setState(new MainMenu());
	}
}
