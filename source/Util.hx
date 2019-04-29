package;

class Util {
	public static function pad(str:String):String {
		return str.length == 1 ? '0' + str : str;
	}

	public static inline function number(num:Float):String {
		var parts:Array<String> = Std.string(Math.round(num * 100) / 100).split('.');

		if (parts.length == 1) {
			parts.push('00');
		} else {
			if (parts[1].length == 1)
				parts[1] = parts[1] + '0';
		}

		return parts.join('.');
	}
}
