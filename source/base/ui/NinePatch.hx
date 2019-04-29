package base.ui;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.geom.Rectangle;

class NinePatch extends Sprite {
  var patches:Array<Array<BitmapData>> = [
    for(i in 0...3) [for(j in 0...3) null]
  ];

  public function new(patchImage: BitmapData, totalWidth: Int, totalHeight: Int, w1: Int, w2: Int, h1: Int, h2: Int) {
    super();

    var w3: Int = patchImage.width - (w1 + w2);
    var h3: Int = patchImage.height - (h1 + h2);

    var rects: Array<Array<Rectangle>> = [
      [new Rectangle(0, 0,       w1, h1), new Rectangle(w1, 0,       w2, h1), new Rectangle(w1 + w2, 0,       w3, h1)],
      [new Rectangle(0, h1,      w1, h2), new Rectangle(w1, h1,      w2, h2), new Rectangle(w1 + w2, h1,      w3, h2)],
      [new Rectangle(0, h1 + h2, w1, h3), new Rectangle(w1, h1 + h2, w2, h3), new Rectangle(w1 + w2, h1 + h2, w3, h3)]
    ];

      for(i in 0...3) {
        for(j in 0...3) {
          patches[i][j] = new BitmapData(Std.int(rects[i][j].width), Std.int(rects[i][j].height), 0x00000000);
          patches[i][j].copyPixels(patchImage, rects[i][j], new Point(0, 0));
        }
      }

      var result: Sprite = new Sprite();

      var corners:BitmapData = new BitmapData(totalWidth, totalHeight, 0x00000000);
      corners.copyPixels(patches[0][0], patches[0][0].rect, new Point(0, 0));
      corners.copyPixels(patches[0][2], patches[0][2].rect, new Point(totalWidth - w3, 0));
      corners.copyPixels(patches[2][0], patches[2][0].rect, new Point(0, totalHeight - h3));
      corners.copyPixels(patches[2][2], patches[2][2].rect, new Point(totalWidth - w3, totalHeight - h3));
      result.addChild(new Bitmap(corners));

      var top:Sprite = new Sprite();
      top.graphics.beginBitmapFill(patches[0][1]);
      top.graphics.drawRect(0, 0, totalWidth - (w1 + w3), h1);
      top.graphics.endFill();
      top.x = w1;
      result.addChild(top);

      var left:Sprite = new Sprite();
      left.graphics.beginBitmapFill(patches[1][0]);
      left.graphics.drawRect(0, 0, w1, totalHeight - (h1 + h3));
      left.graphics.endFill();
      left.y = h1;
      result.addChild(left);

      var right: Sprite = new Sprite();
      right.graphics.beginBitmapFill(patches[1][2]);
      right.graphics.drawRect(0, 0, w3, totalHeight - (h1 + h3));
      right.graphics.endFill();
      right.x = totalWidth - w1;
      right.y = h1;
      result.addChild(right);

      var bottom: Sprite = new Sprite();
      bottom.graphics.beginBitmapFill(patches[2][1]);
      bottom.graphics.drawRect(0, 0, totalWidth - (w1 + w3), h3);
      bottom.graphics.endFill();
      bottom.x = w1;
      bottom.y = totalHeight - h1;
      result.addChild(bottom);

      var middle: Sprite = new Sprite();
      middle.graphics.beginBitmapFill(patches[1][1]);
      middle.graphics.drawRect(0, 0, totalWidth - (w1 + w3), totalHeight - (h1 + h3));
      middle.graphics.endFill();
      middle.x = w1;
      middle.y = h1;
      result.addChild(middle);

      var resultBmp: Bitmap = new Bitmap(new BitmapData(totalWidth, totalHeight, 0x00000000));
      resultBmp.bitmapData.draw(result);

      addChild(resultBmp);
  }
}
