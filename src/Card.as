package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle
	import Math;
	
	/**
	 * ...
	 * @author 何雨航
	 */
	public class Card extends Sprite
	{
		//color
		public static var RED:String = "r";
		public static var GREEN:String = "g";
		public static var YELLOW:String = "y";
		public static var BLUE:String = "b";
		public static var DARK:String = "d";
		//type
		public static var NUM:String = "n";
		public static var RVS:String = "r";
		public static var SKIP:String = "s";
		public static var DT:String = "dt";
		public static var WILD:String = "w";
		public static var WDF:String = "wdf";
		public static var BACK:String = "b";
		
		public var sub:String;
		
		private var _isFront:Boolean = true;
		public var color:String;
		public var type:String;
		public var num:Number;
		public var score:int = 0;
		
		public var tx:Number = 0;
		public var ty:Number = 0;
		
		public var seed:Number = 0;
		
		private var front:Sprite = new Sprite();
		private var back:Sprite = new Sprite();
		public var globalSortIndex:int;
		
		[Embed(source = "../lib/UNO_cards_deck1.png")]
		private var Cards:Class;
		private var cards:Bitmap = new Cards();
		
		public function Card(color:String, type:String, num:int=0)
		{
			this.color = color;
			this.type = type;
			this.num = num;
			if (this.color == DARK)
			{
				this.score = 50;
			}
			else if (this.type == NUM)
			{
				this.score = num;
			}
			else
			{
				this.score = 20;
			}
			//this.front.addChild(this.deck1(color, type, num))
			//this.back.addChild(this.deck1('d', 'b'))
			this.addChild(this.deck1(color, type, num))
			//trace('卡片的尺寸为：' + this.width.toString() + 'x' + this.height.toString())
			addEventListener(Event.ADDED_TO_STAGE, startTrace)
		}
		
		public function startTrace(e:Event):void
		{
			addEventListener(Event.ENTER_FRAME, core)
			//addEventListener(Event.REMOVED_FROM_STAGE)
		}
		
		public function core(e:Event):void
		{
			this.x = this.x + (this.tx - this.x) / 10
			this.y = this.y + (this.ty - this.y) / 10
			if (Math.abs(this.tx - this.x) < 1)
			{
				this.x = this.tx
			}
			if (Math.abs(this.ty - this.y) < 1)
			{
				this.y = this.ty
			}
		
		}
		
		public function set isFront(b:Boolean):void
		{
			if (b)
			{
				this.removeChildren()
				this.addChild(this.deck1(this.color, this.type, this.num))
			}
			else
			{
				this.removeChildren()
				this.addChild(this.deck1(DARK, BACK))
			}
		}
		
		public function setSub(color:String):void
		{
			if (this.type == WILD)
			{
				this.removeChildren()
				this.addChild(this.deck1(color, this.type, this.num))
			}
			else if (this.type == WDF)
			{
				this.removeChildren()
				this.addChild(this.deck1(color, this.type, this.num))
			}
			else
			{
			}
		}
		
		private function deck1(color:String, type:String, num:Number = 12):Bitmap
		{
			var ix:Number = 0;
			var iy:Number = 0;
			
			switch (color)
			{
			case 'r': 
				iy = 0;
				break;
			case 'g': 
				iy = 1;
				break;
			case 'y': 
				iy = 2;
				break;
			case 'b': 
				iy = 3;
				break;
			}
			
			switch (type)
			{
			case 'n': 
				ix = num;
				break;
			case 'r': 
				ix = 10;
				break;
			case 's': 
				ix = 11;
				break;
			case 'dt': 
				ix = 12;
				break;
			case 'w': 
				ix = 0;
				iy = 4;
				switch (color)
				{
				case 'r': 
					ix = 3;
					break;
				case 'g': 
					ix = 4;
					break;
				case 'y': 
					ix = 5;
					break;
				case 'b': 
					ix = 6;
					break;
				}
				break;
			case 'wdf': 
				ix = 1;
				iy = 4;
				switch (color)
				{
				case 'r': 
					ix = 7;
					break;
				case 'g': 
					ix = 8;
					break;
				case 'y': 
					ix = 9;
					break;
				case 'b': 
					ix = 10;
					break;
				}
				break;
			case 'b': 
				ix = 12;
				iy = 4;
				break;
			}
			var dx:Number = cards.width / 13
			var dy:Number = cards.height / 5
			var x:Number = ix * dx
			var y:Number = iy * dy
			var bd:BitmapData = new BitmapData(dx, dy);
			var b:Bitmap = new Bitmap(bd);
			var tmp:Sprite = new Sprite;
			cards.x = -x
			cards.y = -y
			tmp.addChild(cards)
			bd.drawWithQuality(tmp)
			return b
		}
	
	}

}