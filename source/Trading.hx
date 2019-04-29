package;

import openfl.events.MouseEvent;
import base.State;
import base.GameSprite;

class ChangeIndicator extends GameSprite {
	var time:Float = 0;

	public function new(text:String, color:Int) {
		super();

		addChild(new Text(text, color));
	}

	override public function update(delta:Float) {
		y += delta;
		if (time >= 3) {
			parent.removeChild(this);
		} else {
			time += delta;
		}
	}
}

class Trading extends State {
	var life:Float = 10;
	var usd:Float = 100;
	var chart:Chart;
	var lifeBalance:Text;
	var usdBalance:Text;
	var percentButtons:Array<Button> = [];
	var fraction:Float = 0.5;
	var instructionsDone:Bool = false;

	public function new() {
		super();

		lifeBalance = new Text('', Colors.DARK_BLUE);
		lifeBalance.x = 4;
		lifeBalance.y = 4;
		addChild(lifeBalance);

		usdBalance = new Text('', Colors.DARK_BLUE);
		usdBalance.x = Main.WIDTH;
		usdBalance.y = 4;
		addChild(usdBalance);

		var payButton:Button = new Button('PAY BILL ($10,000)', Colors.LIGHT_BLUE, 0x0, 100);
		payButton.y = lifeBalance.y + lifeBalance.height + 4;
		payButton.x = (Main.WIDTH - payButton.width) / 2;
		payButton.addEventListener(MouseEvent.MOUSE_DOWN, payBill);
		addChild(payButton);

		updateBalance();

		chart = new Chart();
		chart.x = 4;
		chart.y = payButton.y + payButton.height + 4;

		addChild(chart);

		var buyButton = new Button('BUY LIFE', Colors.GREEN);
		var btnY = Main.HEIGHT - buyButton.height - 2;
		buyButton.x = 4;
		buyButton.y = btnY;
		addChild(buyButton);

		var sellButton = new Button('SELL LIFE', Colors.RED);
		sellButton.x = buyButton.x + buyButton.width + 5;
		sellButton.y = btnY;
		addChild(sellButton);

		var nextX = sellButton.x + sellButton.width + 4;
		for (i in [10, 25, 50, 75, 90]) {
			var percentBtn:Button = new Button('$i%', 0x8a8fc4, 0xf0d472, 20);
			percentBtn.x = nextX;
			percentBtn.y = btnY;
			percentBtn.addEventListener(MouseEvent.MOUSE_DOWN, function(event) {
				for (btn in percentButtons) {
					btn.active = false;
				}
				percentBtn.active = true;
				fraction = i / 100;
			});
			addChild(percentBtn);
			percentButtons.push(percentBtn);
			nextX += percentBtn.width + 2;
		}

		percentButtons[2].active = true;
		buyButton.addEventListener(MouseEvent.MOUSE_DOWN, buy);

		sellButton.addEventListener(MouseEvent.MOUSE_DOWN, sell);

		showDialog('WELCOME TO LIFE STOCK EXCHANGE!', function() {
			showDialog('HERE YOU CAN SELL YOUR LIFE\nFOR REAL MONEY!', function() {
				showDialog('AND ALSO BUY SOME\nIF YOU\'VE GOT CASH', function() {
					showDialog('BUY LIFE WHEN THE PRICE IS LOW', function() {
						showDialog('RIGHT NOW IT\'S ONLY ABOUT 1$\nMAYBE IT\'S TIME TO BUY!', function() {
							showDialog('WHEN THE PRICE IS HIGH\nSELL SOME LIFE TO GET $' + '$' + '$', function() {
								showDialog('YOU NEED $10,000\nTO PAY THE HOSPITAL BILLS', function() {
									showDialog("AND REMEBER THAT YOU'RE DYING\nSO YOU'RE CONSTANTLY RUNNING\nOUT OF LIFE", function() {
										showDialog('GOOD LUCK!', function() {
											instructionsDone = true;
										});
									});
								});
							});
						});
					});
				});
			});
		});
	}

	function showDialog(message:String, callback:Void->Void) {
		var dialog = new DialogBox(message, callback);
		dialog.x = (Main.WIDTH - dialog.width) / 2;
		dialog.y = (Main.HEIGHT - dialog.height) / 2;
		addChild(dialog);
	}

	function updateBalance() {
		this.lifeBalance.text = 'LIFE: ' + Util.number(life);
		this.usdBalance.text = '$' + Util.number(usd);
		this.usdBalance.x = Main.WIDTH - usdBalance.width - 4;
	}

	function buy(event:MouseEvent) {
		var addLife = usd / chart.currentPrice;

		if (addLife > 0) {
			var lifeInd = new ChangeIndicator('+' + Util.number(addLife), Colors.GREEN);
			lifeInd.x = lifeBalance.x;
			lifeInd.y = lifeBalance.y + lifeBalance.height;
			addChild(lifeInd);

			var usdInd = new ChangeIndicator('-$' + Util.number(usd), Colors.RED);
			usdInd.x = Main.WIDTH - usdInd.width - 4;
			usdInd.y = usdBalance.y + usdBalance.height;
			addChild(usdInd);

			life += addLife;
			usd = 0;
			updateBalance();
		}
	}

	function sell(event:MouseEvent) {
		var lives = life * fraction;
		var addUsd = chart.currentPrice * lives;

		var lifeInd = new ChangeIndicator('-' + Util.number(lives), Colors.RED);
		lifeInd.x = lifeBalance.x;
		lifeInd.y = lifeBalance.y + lifeBalance.height;
		addChild(lifeInd);

		var usdInd = new ChangeIndicator('+$' + Util.number(addUsd), Colors.GREEN);
		usdInd.x = Main.WIDTH - usdInd.width - 4;
		usdInd.y = usdBalance.y + usdBalance.height;
		addChild(usdInd);

		usd += addUsd;
		life -= lives;

		updateBalance();
	}

	function payBill(e:MouseEvent) {
		if (usd >= 10000) {
			usd -= 10000;

			updateBalance();

			machine.setState(new Outro());
		} else {
			showDialog("NOT ENOUGH MONEY", function() {});
		}
	}

	override public function update(delta:Float) {
		if (instructionsDone) {
			life = Math.max(0, life - delta * 0.25);
			updateBalance();

			if (life == 0) {
				machine.setState(new Death());
			}
		}

		super.update(delta);
	}
}
