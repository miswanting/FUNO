package
{
	import flash.display.Sprite;
	import Card;
	
	/**
	 * ...
	 * @author 何雨航
	 */
	public class Game extends Sprite
	{
		public var allCards:Array = new Array();
		
		public function Game()
		{
		
		}
		
		public function start()
		{
			
			generateAllCards()
			showAllCards()
		}
		
		private function generateAllCards():void
		{
			for (var i:int = 0; i < 10; i++)
			{
				allCards.push(new Card('r', 'n', i))
				allCards.push(new Card('y', 'n', i))
				allCards.push(new Card('g', 'n', i))
				allCards.push(new Card('b', 'n', i))
			}
			for (var i:int = 1; i < 10; i++)
			{
				allCards.push(new Card('r', 'n', i))
				allCards.push(new Card('y', 'n', i))
				allCards.push(new Card('g', 'n', i))
				allCards.push(new Card('b', 'n', i))
			}
			for (var i:int = 0; i < 2; i++)
			{
				allCards.push(new Card('r', 'r', i))
				allCards.push(new Card('y', 'r', i))
				allCards.push(new Card('g', 'r', i))
				allCards.push(new Card('b', 'r', i))
				allCards.push(new Card('r', 's', i))
				allCards.push(new Card('y', 's', i))
				allCards.push(new Card('g', 's', i))
				allCards.push(new Card('b', 's', i))
				allCards.push(new Card('r', 'dt', i))
				allCards.push(new Card('y', 'dt', i))
				allCards.push(new Card('g', 'dt', i))
				allCards.push(new Card('b', 'dt', i))
				allCards.push(new Card('d', 'w', i))
				allCards.push(new Card('d', 'w', i))
				allCards.push(new Card('d', 'wdf', i))
				allCards.push(new Card('d', 'wdf', i))
			}
		}
		
		private function showAllCards():void
		{
			for (var i:int = 0; i < allCards.length; i++)
			{
				addChild(allCards[i])
				allCards[i].tx = (stage.stageWidth - allCards[i].width) / 2
				allCards[i].ty = (stage.stageHeight - allCards[i].height) / 2
			}
		}
	
	}

}