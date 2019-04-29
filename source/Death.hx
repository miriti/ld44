package;

class Death extends DoctorDialog {
	public function new() {
		super(['D WELL...', 'D TIME OF DEATH: ${time()}'], function() {
			machine.setState(new MainMenu());
		});
	}

	public function time():String {
		var date = Date.now();
		return date.getHours() + ":" + Util.pad(Std.string(date.getMinutes()));
	}
}
