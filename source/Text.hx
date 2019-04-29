package;

import openfl.Assets;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

class Text extends Sprite {
	public var text(default, set):String;
	public var center:Bool = false;

	var bitmap:Bitmap = new Bitmap();
	var _text:String;

	public var color:Int;

	function set_text(str:String):String {
		text = str;
		draw();
		return text;
	}

	function set_color(val:Int):Int {
		color = val;
		return color;
	}

	function draw() {
		var str = this.text;
		var sheet = Assets.getBitmapData('assets/font.png');
		var len = str.length;

		var bitmapData = new BitmapData(len * 5, 5, true, 0x00000000);

		for (i in 0...len) {
			var c:Int = str.charCodeAt(i) - ' '.charCodeAt(0);
			bitmapData.copyPixels(sheet, new Rectangle(c * 4, 0, 4, 5), new Point(i * 5, 0));
		}

		var r:Float = ((color >> 16) & 255) / 255;
		var g:Float = ((color >> 8) & 255) / 255;
		var b:Float = (color & 255) / 255;

		bitmapData.colorTransform(bitmapData.rect, new ColorTransform(r, g, b, 1, 0, 0, 0, 0));

		bitmap.bitmapData = bitmapData;

		if (center) {
			bitmap.x = -bitmap.width / 2;
		}
	}

	public function new(str:String, color:Int = 0xf9f5ef) {
		super();

		addChild(bitmap);

		this.color = color;
		this.text = str;
	}
}
