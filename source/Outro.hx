package;

class Outro extends DoctorDialog {
	public function new() {
		super([
			"D WOW! YOU'VE MADE IT!",
			"P YEP",
			"D UNBELIEVABLE!",
			"D WELL. CONGRATULATIONS!",
			"P THANKS",
			"D DO YOU WANT TO MANAGE MY FINANCES?",
			"P NO",
			"D OKAY"
		], function() {
			machine.setState(new MainMenu());
		});
	}
}
