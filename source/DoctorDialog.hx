package;

import openfl.Assets;
import openfl.events.MouseEvent;
import base.State;
import aseprite.Aseprite;

class DoctorDialog extends State {
	var doctor:Aseprite;
	var patient:Aseprite;
	var skipButton:Button;
	var totalTime:Float = 0;
	var dialog:Array<String>;
	var currentLineIndex:Int = -1;
	var dialogText:Text;
	var dialogDelay:Float = 0;
	var currentLine:String = '';
	var callback:Void->Void;
	var letterTime:Float = 0;

	public function new(dialog:Array<String>, callback:Void->Void) {
		super();

		this.dialog = dialog;
		this.callback = callback;

		doctor = new Aseprite('assets/anim/doctor');
		doctor.x = 95;
		doctor.y = 42;
		addChild(doctor);

		patient = new Aseprite('assets/anim/patient');
		patient.x = 55;
		patient.y = 65;
		addChild(patient);

		skipButton = new Button('SKIP>', Colors.GREEN);
		skipButton.x = Main.WIDTH - skipButton.width - 4;
		skipButton.y = Main.HEIGHT - skipButton.height - 4;
		skipButton.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent) {
			callback();
		});
		addChild(skipButton);

		dialogText = new Text('', Colors.DARK_BLUE);
		dialogText.center = true;
		addChild(dialogText);
	}

	function say(str:String) {
		currentLine = str.substr(2);

		doctor.pause();
		doctor.currentFrameIndex = 0;

		patient.pause();
		patient.currentFrameIndex = 0;

		var side:String = str.substr(0, 1);
		dialogText.text = '';
		dialogDelay = currentLine.split(' ').length * 0.2 + 1.5;

		var lipsTimes:Int = Math.round(currentLine.length * 0.4);

		var actor:Aseprite = null;

		if (side == 'D') {
			dialogText.x = doctor.x + doctor.width / 2;
			dialogText.y = doctor.y - dialogText.height - 3;
			actor = doctor;
		}

		if (side == 'P') {
			dialogText.x = 175;
			dialogText.y = 35;
			actor = patient;
		}

		actor.playTimes(lipsTimes, null, function() {
			actor.pause();
			actor.currentFrameIndex = 0;
		});
	}

	override public function update(delta:Float) {
		super.update(delta);

		if (currentLineIndex != -1) {
			if (dialogDelay <= 0) {
				currentLineIndex++;

				if (currentLineIndex < dialog.length) {
					say(dialog[currentLineIndex]);
				} else {
					callback();
				}
			} else {
				if (letterTime >= 1 / 30) {
					if (dialogText.text.length < currentLine.length) {
						dialogText.text = dialogText.text + currentLine.charAt(dialogText.text.length);
						Assets.getSound('assets/snd/speach.ogg').play();
					}
					letterTime = 0;
				} else {
					letterTime += delta;
				}
				dialogDelay -= delta;
			}
		} else {
			if (totalTime >= 1) {
				currentLineIndex = 0;
				say(dialog[currentLineIndex]);
			}
		}

		totalTime += delta;
	}
}
