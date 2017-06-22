package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import Card;
	
	/**
	 * ...
	 * @author 何雨航
	 */
	public class Player extends Sprite
	{
		public var names:String = 'test';
		public var score:int = 0;
		public var handP:Point;
		public var cardsInHand:Array = new Array;
		private var allCards:Array;
		private var cardD:Number = 30;
		private var isExtend:Boolean = false;
		
		public function Player(allCards:Array)
		{
			this.allCards = allCards;
		}
		
		public function extend():void
		{
			isExtend = true;
		}
		
		public function giveCard(card:Card):void
		{
			cardsInHand.push(card)
			if (isExtend)
			{
				var l:Number = cardsInHand[cardsInHand.length - 1].width + cardD * (cardsInHand.length - 1)
				for (var i:int = 0; i < cardsInHand.length; i++)
				{
					cardsInHand[i].tx = handP.x - l / 2 + i * cardD;
				}
			}
			else
			{
				card.tx = handP.x - card.width / 2;
			}
			card.ty = handP.y - card.height / 2;
		}
		
		public function showHand():void
		{
			for (var i:int = 0; i < cardsInHand.length; i++)
			{
				cardsInHand[i].isFront = true;
			}
		}
		
		public function sortHand():void
		{
			if (cardsInHand.length > 0)
			{
				cardsInHand.sortOn('globalSortIndex', Array.NUMERIC);
				if (isExtend)
				{
					var l:Number = cardsInHand[cardsInHand.length - 1].width + cardD * (cardsInHand.length - 1)
					for (var i:int = 0; i < cardsInHand.length; i++)
					{
						cardsInHand[i].tx = handP.x - l / 2 + i * cardD;
					}
				}
			}
		}
		
		public function fetchCard(seed:Number):*
		{
			for (var i:int = 0; i < cardsInHand.length; i++)
			{
				if (cardsInHand[i].seed == seed)
				{
					var tmp:Card = cardsInHand.removeAt(i)
					return tmp
				}
			}
		}
	
	}

}