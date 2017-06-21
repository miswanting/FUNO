package
{
	import Card;
	import Math;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author 何雨航
	 */
	public class Game extends Sprite
	{
		private var allCards:Array = new Array();
		private var timer:Timer = new Timer(2000);
		public var playerAmount:int = 4;
		private var l_player:Array = new Array()
		
		private var cardUnused:Array = new Array();
		private var cardUsed:Array = new Array();
		
		private var currentTask:String = 'coverAllCards';
		private var bossIndex:int;
		
		private var tmp_int:int;
		private var currentPlayerIndex:int;
		private var isClockwise:Boolean = false;
		
		public function Game()
		{
		
		}
		
		public function start():void
		{
			
			generateAllCards()
			showAllCards()
			this.timer.delay = 2000
			this.timer.addEventListener(TimerEvent.TIMER, step)
			this.timer.start()
		}
		
		private function step(e:Event)
		{
			trace(currentTask)
			switch (currentTask)
			{
			case 'coverAllCards': 
				for (var i:int = 0; i < allCards.length; i++)
				{
					allCards[i].isFront = false;
				}
				
				currentTask = 'resetAllCards';
				this.timer.delay = 500
				break;
			case 'resetAllCards': 
				trace(allCards.length)
				for (var i:int = 0; i < allCards.length; i++)
				{
					allCards[i].tx = (stage.stageWidth - allCards[i].width) / 2
					allCards[i].ty = (stage.stageHeight - allCards[i].height) / 2
					allCards[i].seed = Math.random()
				}
				
				allCards.sortOn('seed')
				for (var i:int = 0; i < allCards.length; i++)
				{
					removeChild(allCards[i])
					addChild(allCards[i])
				}
				cardUnused = allCards.concat();
				
				currentTask = 'showAllPlayer';
				this.timer.delay = 1500
				break;
			case 'showAllPlayer': 
				for (var i:int = 0; i < playerAmount; i++)
				{
					var player:Player = new Player(allCards);
					var x = stage.stageWidth / 2 + stage.stageWidth / 2.5 * Math.sin(2*Math.PI/playerAmount  * i)
					var y = stage.stageHeight / 2 + stage.stageHeight / 2.5 * Math.cos(2*Math.PI /playerAmount * i)
					player.handP = new Point(x, y);
					addChild(player)
					l_player.push(player);
					var tmp:Card = cardUnused.pop()
					removeChild(tmp)
					addChild(tmp)
					l_player[i].giveCard(tmp)
						//allCards[allCards.length - 1 - i].tx = l_player[i].handP.x - allCards[allCards.length - 1 - i].width / 2;
						//allCards[allCards.length - 1 - i].ty = l_player[i].handP.y - allCards[allCards.length - 1 - i].height / 2;
				}
				currentTask = 'flipCards';
				this.timer.delay = 1500
				break;
			case 'flipCards': 
				//翻牌
				for (var i:int = 0; i < playerAmount; i++)
				{
					l_player[i].cardsInHand[l_player[i].cardsInHand.length - 1].isFront = true;
				}
				currentTask = 'checkIsNum';
				this.timer.delay = 1000
				break;
			case 'checkIsNum': 
				var isAllNum = true;
				for (var i:int = 0; i < playerAmount; i++)
				{
					if (l_player[i].cardsInHand[l_player[i].cardsInHand.length - 1].type != 'n')
					{
						isAllNum = false;
						var tmp:Card = cardUnused.pop()
						removeChild(tmp)
						addChild(tmp)
						l_player[i].giveCard(tmp)
					}
				}
				if (isAllNum)
				{
					//全为数字
					//进行数字比较
					currentTask = 'checkMax';
					this.timer.delay = 1500
				}
				else
				{
					currentTask = 'flipCards';
				}
				this.timer.delay = 500
				break;
			case 'checkMax': 
				var l_num:Array = new Array();
				for (var i:int = 0; i < playerAmount; i++)
				{
					l_num.push(l_player[i].cardsInHand[l_player[i].cardsInHand.length - 1].num)
				}
				var max:int = Math.max.apply(null, l_num)
				var amount:int = 0;
				for (var i:int = 0; i < playerAmount; i++)
				{
					if (l_player[i].cardsInHand[l_player[i].cardsInHand.length - 1].num == max)
					{
						bossIndex = i
						amount++;
					}
				}
				if (amount != 1)
				{
					trace('最大值', max, '有', amount, '张牌!')
					for (var i:int = 0; i < playerAmount; i++)
					{
						trace(i, l_player[i].cardsInHand[l_player[i].cardsInHand.length - 1].num, '是否发牌？')
						if (l_player[i].cardsInHand[l_player[i].cardsInHand.length - 1].num == max)
						{
							trace('发牌！')
							var tmp:Card = cardUnused.pop()
							removeChild(tmp)
							addChild(tmp)
							l_player[i].giveCard(tmp)
						}
					}
					currentTask = 'flipCards';
					this.timer.delay = 1500
					break;
				}
				currentTask = 'messCards';
				this.timer.delay = 1000
				break;
			case 'messCards': 
				trace('庄家是：', bossIndex, allCards.length)
				for (var i:int = 0; i < allCards.length; i++)
				{
					allCards[i].isFront = false;
					allCards[i].tx = (stage.stageWidth - allCards[i].width) / 2
					allCards[i].ty = (stage.stageHeight - allCards[i].height) / 2
					allCards[i].seed = Math.random()
				}
				
				allCards.sortOn('seed')
				for (var i:int = 0; i < allCards.length; i++)
				{
					removeChild(allCards[i])
					addChild(allCards[i])
				}
				cardUnused = allCards.concat();
				currentPlayerIndex = bossIndex;
				tmp_int = 0;
				for (var i:int = 0; i < playerAmount; i++)
				{
					l_player[i].cardsInHand = new Array;
				}
				l_player[0].extend();
				currentTask = 'give7';
				this.timer.delay = 500
				break;
			case 'give7': 
				if (currentPlayerIndex >= playerAmount)
				{
					currentPlayerIndex = 0
				}
				else if (currentPlayerIndex <= -1)
				{
					currentPlayerIndex = playerAmount - 1
				}
				
				var tmp:Card = cardUnused.pop()
				removeChild(tmp)
				addChild(tmp)
				l_player[currentPlayerIndex].giveCard(tmp)
				currentPlayerIndex++;
				tmp_int++;
				this.timer.delay = 200
				if (tmp_int >= 7 * playerAmount)
				{
					currentTask = 'showHand';
					this.timer.delay = 1000
				}
				break;
			case 'showHand': 
				l_player[0].showHand()
				currentTask = 'sortHand';
				break;
			case 'sortHand': 
				l_player[0].sortHand()
				for (var i:int = 0; i < l_player[0].cardsInHand.length; i++)
				{
					removeChild(l_player[0].cardsInHand[i])
					addChild(l_player[0].cardsInHand[i])
				}
				currentTask = 'startOfStart';
				break;
			case 'startOfStart': 
				currentPlayerIndex++;
				
				currentTask = 'start';
				break;
			case 'start': 
				if (isClockwise)
				{
					currentPlayerIndex--;
				}
				else
				{
					currentPlayerIndex++;
				}
				l_player[0].showHand()
				currentTask = 'exit';
				break;
			case 'exit': 
				this.timer.reset()
			}
		}
		
		public function isAllCardsNotMoving():Boolean
		{
			for (var i:int = 0; i < 10; i++)
			{
				if (allCards[i].x != allCards[i].tx)
				{
					return false
				}
				if (allCards[i].y != allCards[i].ty)
				{
					return false
				}
			}
			return true
		}
		
		private function generateAllCards():void
		{
			function normalG(color:String):void
			{
				allCards.push(new Card(color, 'n', 0))
				for (var i:int = 1; i < 10; i++)
				{
					allCards.push(new Card(color, 'n', i))
					allCards.push(new Card(color, 'n', i))
				}
				allCards.push(new Card(color, 'r', 0))
				allCards.push(new Card(color, 'r', 0))
				allCards.push(new Card(color, 's', 0))
				allCards.push(new Card(color, 's', 0))
				allCards.push(new Card(color, 'dt', 0))
				allCards.push(new Card(color, 'dt', 0))
			}
			normalG('r');
			normalG('y');
			normalG('g');
			normalG('b');
			allCards.push(new Card('d', 'w', 0))
			allCards.push(new Card('d', 'w', 0))
			allCards.push(new Card('d', 'w', 0))
			allCards.push(new Card('d', 'w', 0))
			allCards.push(new Card('d', 'wdf', 0))
			allCards.push(new Card('d', 'wdf', 0))
			allCards.push(new Card('d', 'wdf', 0))
			allCards.push(new Card('d', 'wdf', 0))
			for (var i:int = 1; i < allCards.length; i++)
			{
				allCards[i].globalSortIndex = i;
			}
		}
		
		private function showAllCards():void
		{
			for (var i:int = 0; i < allCards.length; i++)
			{
				allCards[i].x = (stage.stageWidth - allCards[i].width) / 2
				allCards[i].y = (stage.stageHeight - allCards[i].height) / 2
				addChild(allCards[i])
				allCards[i].addEventListener(MouseEvent.MOUSE_UP, imove)
				var tx:Number = Math.random() * (stage.stageWidth - allCards[i].width) + allCards[i].width / 2
				var ty:Number = Math.random() * (stage.stageHeight - allCards[i].height) + allCards[i].height / 2
				allCards[i].tx = tx - allCards[i].width / 2
				allCards[i].ty = ty - allCards[i].height / 2
			}
		}
		
		private function imove(e:MouseEvent):void
		{
			//var tx:Number = Math.random() * (stage.stageWidth - e.target.width) + e.target.width / 2
			//var ty:Number = Math.random() * (stage.stageHeight - e.target.height) + e.target.height / 2
			//e.target.tx = tx - e.target.width / 2
			//e.target.ty = ty - e.target.height / 2
			//trace(e.target.seed)
			//for (var i:int = 0; i < allCards.length; i++)
			//{
				//if (e.target.seed == allCards[i].seed)
				//{
					//removeChild(allCards[i])
					//addChild(allCards[i])
				//}
			//}
		}
	
	}

}