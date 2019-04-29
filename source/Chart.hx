package;

import openfl.display.Sprite;
import base.GameSprite;

typedef Candle = {
	open:Float,
	high:Float,
	low:Float,
	close:Float,
	volume:Float
}

typedef Flactuation = {
	trend:Float,
	amplitude:Float,
	phaseSpeed:Float,
	time:Float
}

class Chart extends GameSprite {
	public static inline var WIDTH:Int = 200;
	public static inline var HEIGHT:Int = 120;
	public static inline var STEP:Int = 20;

	public var currentPrice(get, never):Float;

	var background:Sprite;
	var candlesLayer:Sprite;
	var closeText:Text = new Text('1234', 0x47416b);
	var linesText:Array<Text> = [];
	var renderData:Array<Candle> = [];
	var totalTime:Float = 0;
	var time:Float = 0;
	var flactuationTime:Float = 0;
	var currentFlactuation:Int = 0;
	var nextFlactuation:Int = 1;
	var flactuationPhase:Float = 0;
	var priceDelay:Float = 0;
	var priceTime:Float = 0.5;
	var prevClose:Float = 1;
	var nextClose:Float = 1;
	var grandTrend:Float = 0;
	var flactuationPoints:Array<Flactuation> = [
		{
			trend: 1,
			amplitude: 0.2,
			time: 5,
			phaseSpeed: Math.PI / 4
		}, {
			trend: 1,
			amplitude: 0.5,
			time: 20,
			phaseSpeed: Math.PI
		},
		{
			trend: 4,
			amplitude: 2,
			time: 20,
			phaseSpeed: Math.PI * 2
		}, {
			trend: 1.5,
			amplitude: 1,
			time: 15,
			phaseSpeed: Math.PI * 2
		},
		{
			trend: 6,
			amplitude: 3,
			time: 10,
			phaseSpeed: Math.PI / 8
		}, {
			trend: 7,
			amplitude: 1,
			time: 20,
			phaseSpeed: Math.PI / 2
		},
		{
			trend: 2,
			amplitude: 5,
			time: 13,
			phaseSpeed: Math.PI
		}, {
			trend: 1,
			amplitude: 1,
			time: 10,
			phaseSpeed: Math.PI / 8
		},
		{
			trend: 4,
			amplitude: 2,
			time: 20,
			phaseSpeed: Math.PI / 4
		}, {
			trend: 10,
			amplitude: 5,
			time: 30,
			phaseSpeed: Math.PI
		}
	];

	function get_currentPrice():Float {
		return renderData[renderData.length - 1].close;
	}

	public function new() {
		super();

		background = new Sprite();
		candlesLayer = new Sprite();

		background.graphics.beginFill(0xf9f5ef);
		background.graphics.drawRect(0, 0, WIDTH, HEIGHT);
		background.graphics.endFill();

		background.graphics.lineStyle(1, 0x8a8fc4);

		for (line in 0...Math.floor(120 / STEP)) {
			background.graphics.moveTo(0, line * STEP);
			background.graphics.lineTo(200, line * STEP);

			var newLabel = new Text('', 0x8a8fc4);
			newLabel.x = WIDTH + 2;
			newLabel.y = line * STEP - newLabel.height / 2;
			addChild(newLabel);
			linesText.push(newLabel);
		}

		addChild(background);
		addChild(candlesLayer);

		addChild(closeText);

		renderData.push({
			open: 1,
			high: 1,
			low: 1,
			close: 1,
			volume: 0
		});

		render();
	}

	override public function update(delta:Float) {
		super.update(delta);

		var current = renderData[renderData.length - 1];

		if (time > 5) {
			renderData.push({
				open: current.close,
				high: current.close,
				low: current.close,
				close: current.close,
				volume: 0
			});
			if (renderData.length > 50) {
				renderData = renderData.slice(renderData.length - 50);
			}
			time = 0;
		} else {
			time += delta;
			totalTime += delta;

			if (priceDelay <= 0) {
				var cT = flactuationPoints[currentFlactuation].trend;
				var nT = flactuationPoints[nextFlactuation].trend;
				var t = flactuationPoints[nextFlactuation].time;

				if (flactuationTime >= t) {
					currentFlactuation = nextFlactuation;
					nextFlactuation++;
					if (nextFlactuation == flactuationPoints.length) {
						nextFlactuation = 0;
						var g = Math.round(prevClose);
						grandTrend = 1 + (g * 0.15 + Math.random() * (g * 0.85));
					}
					flactuationTime = 0;
				} else {
					var camp = flactuationPoints[currentFlactuation].amplitude;
					var amp = flactuationPoints[nextFlactuation].amplitude;
					var tt = (flactuationTime / t);
					prevClose = nextClose;
					nextClose = grandTrend + Math.max(0.01, cT
						+ (nT - cT) * tt
						+ (Math.cos(flactuationPhase) * (camp + (amp - camp) * tt)) * Math.random());
				}
				priceDelay = priceTime;
			} else {
				var t = (1 - (priceDelay / priceTime));
				current.close = prevClose + (nextClose - prevClose) * Math.sqrt(t);
				current.high = Math.max(current.high, current.close);
				current.low = Math.min(current.low, current.close);
				priceDelay -= delta;
			}

			flactuationTime += delta;
			flactuationPhase += delta * flactuationPoints[currentFlactuation].phaseSpeed;
		}

		render();
	}

	public function render() {
		if (renderData.length > 0) {
			var min:Float = 1000000;
			var max:Float = -1000000;

			candlesLayer.graphics.clear();

			for (candle in renderData) {
				if (candle.low < min) {
					min = candle.low;
				}

				if (candle.high > max) {
					max = candle.high;
				}
			}

			if (max - min < 10) {
				max = min + 10;
			}

			var plot = function(x:Float):Float {
				return (HEIGHT - (HEIGHT * ((x - min) / (max - min))));
			};

			for (k in 0...renderData.length) {
				var candle:Candle = renderData[k];
				candlesLayer.graphics.lineStyle(1, 0x47416b);
				candlesLayer.graphics.moveTo(k * 4 + 1.5, plot(candle.high));
				candlesLayer.graphics.lineTo(k * 4 + 1.5, plot(candle.low));

				candlesLayer.graphics.lineStyle(null);

				candlesLayer.graphics.beginFill(candle.close > candle.open ? 0x6c8c50 : 0xa13d3b);
				candlesLayer.graphics.drawRect(k * 4, plot(candle.open), 3, plot(candle.close) - plot(candle.open));
				candlesLayer.graphics.endFill();
			}

			var lineIndex = 0;
			var numLines = Math.floor(120 / STEP);
			for (line in 0...numLines) {
				var value:Float = min + (max - min) * (1 - (line / numLines));
				linesText[lineIndex].text = value >= 0 ? ' $' + Util.number(value) : '';
				lineIndex++;
			}

			var last:Candle = renderData[renderData.length - 1];

			candlesLayer.graphics.lineStyle(1, 0x47416b);
			candlesLayer.graphics.moveTo(0, plot(last.close));
			candlesLayer.graphics.lineTo(WIDTH, plot(last.close));

			closeText.text = '<$' + Util.number(last.close);
			closeText.x = WIDTH + 2;
			closeText.y = plot(last.close) - closeText.height / 2;
		}
	}
}
