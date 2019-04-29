package base;

import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import aseprite.Aseprite;

typedef TimerDescriptor = {
	time:Float,
	action:Void->Void
};

class GameSprite extends Sprite {
	public var bitmap:Bitmap;
	public var updating:Bool = true;

	var childGameSprites:Array<GameSprite> = [];
	var animations:Array<Aseprite> = [];
	var currentTween:Tween = null;
	var timers:Array<TimerDescriptor> = [];

	public function new(?assetId:String = null, ?centered:Bool = false, ?shiftX:Float = 0, ?shiftY:Float = 0) {
		super();

		if (assetId != null) {
			bitmap = new Bitmap(Assets.getBitmapData(assetId));
			if (centered) {
				bitmap.x = -bitmap.width / 2;
				bitmap.y = -bitmap.height / 2;
			} else {
				bitmap.x = shiftX;
				bitmap.y = shiftY;
			}

			addChild(bitmap);
		}
	}

	/**
	 * Update
	 */
	public function update(delta:Float):Void {
		if (updating) {
			if (currentTween != null) {
				currentTween = currentTween.update(delta);
			}

			for (timer in timers) {
				if (timer.time <= 0) {
					timer.action();
					timers.remove(timer);
				} else {
					timer.time -= delta;
				}
			}

			for (child in childGameSprites) {
				child.update(delta);
			}

			for (animation in animations) {
				animation.update(Math.round(1000 * delta));
			}
		}
	}

	override public function addChild(child:DisplayObject):DisplayObject {
		if (Std.is(child, GameSprite)) {
			if (childGameSprites.indexOf(cast child) == -1) {
				childGameSprites.push(cast child);
			}
		}

		if (Std.is(child, Aseprite)) {
			if (animations.indexOf(cast child) == -1) {
				animations.push(cast child);
			}
		}
		return super.addChild(child);
	}

	override public function removeChild(child:DisplayObject):DisplayObject {
		if (Std.is(child, GameSprite)) {
			childGameSprites.remove(cast child);
		}
		if (Std.is(child, Aseprite)) {
			animations.remove(cast child);
		}
		return super.removeChild(child);
	}

	public function keyDown(keyCode:Int, ctrl:Bool, alt:Bool, shift:Bool) {
		for (child in childGameSprites) {
			if (child.visible) {
				child.keyDown(keyCode, ctrl, alt, shift);
			}
		}
	}

	public function keyUp(keyCode:Int, ctrl:Bool, alt:Bool, shift:Bool) {
		for (child in childGameSprites) {
			if (child.visible) {
				child.keyUp(keyCode, ctrl, alt, shift);
			}
		}
	}

	/**
	 *  Timer
	 *
	 *  @param time -
	 *  @param action -
	 */
	public function timer(time:Float, action:Void->Void) {
		var newTimer = {
			time: time,
			action: action
		};

		timers.push(newTimer);

		return newTimer;
	}

	public function stopTimer(timer:TimerDescriptor) {
		timers.remove(timer);
	}

	/**
	 *
	 */
	public function tween(properties:Dynamic, time:Float, onComplete:Void->Void = null) {
		return currentTween = new Tween(this, time, properties);
	}
}
