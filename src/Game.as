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
		
		private var tmp_int:int; //发牌计数
		private var currentPlayerIndex:int;
		private var isClockwise:int = -1;
		
		private var cardNewlyPlayed:Boolean = false;
		private var gameNewlyStarted:Boolean = false;
		
		private var colorChooser:Sprite = new Sprite;
		
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
			if (currentTask != 'give7')
			{
				trace('[', currentTask, ']')
			}
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
					var x = stage.stageWidth / 2 + stage.stageWidth / 2.5 * Math.sin(2 * Math.PI / playerAmount * i)
					var y = stage.stageHeight / 2 + stage.stageHeight / 2.5 * Math.cos(2 * Math.PI / playerAmount * i)
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
				if (currentPlayerIndex >= playerAmount)
				{
					currentPlayerIndex = 0;
				}
				else if (currentPlayerIndex <= -1)
				{
					currentPlayerIndex = playerAmount - 1;
				}
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
				currentTask = 'bossChooseColor';
				this.timer.delay = 2000;
				break;
			case 'bossChooseColor': 
				var tmp:Card = cardUnused.pop()
				removeChild(tmp)
				addChild(tmp)
				var target:Point = getRamUsedCardP()
				tmp.tx = target.x
				tmp.ty = target.y
				cardUsed.push(tmp)
				currentTask = 'flipBossColorCard';
				this.timer.delay = 1000;
				break;
			case 'flipBossColorCard': 
				cardUsed[cardUsed.length - 1].isFront = true;
				trace(cardUsed[cardUsed.length - 1].color);
				gameNewlyStarted = true;
				if (cardUsed[cardUsed.length - 1].type == Card.RVS)
				{
					trace('庄家翻牌为：转向牌。顺序改变。')
					isClockwise = -isClockwise
					currentTask = '系统判定';
				}
				else if (cardUsed[cardUsed.length - 1].type == Card.SKIP)
				{
					trace('庄家翻牌为：跳过牌。下家任意出。')
					currentTask = '系统判定';
				}
				else if (cardUsed[cardUsed.length - 1].type == Card.DT)
				{
					trace('庄家翻牌为：+2牌。庄家抽两张。')
					var tmp:Card = cardUnused.pop()
					removeChild(tmp)
					addChild(tmp)
					l_player[currentPlayerIndex].giveCard(tmp)
					var tmp:Card = cardUnused.pop()
					removeChild(tmp)
					addChild(tmp)
					l_player[currentPlayerIndex].giveCard(tmp)
					if (currentPlayerIndex == 0)
					{
						l_player[currentPlayerIndex].cardsInHand[l_player[currentPlayerIndex].cardsInHand.length - 2].isFront = true;
						l_player[currentPlayerIndex].cardsInHand[l_player[currentPlayerIndex].cardsInHand.length - 1].isFront = true;
						l_player[currentPlayerIndex].sortHand()
						for (var i:int = 0; i < l_player[currentPlayerIndex].cardsInHand.length; i++)
						{
							removeChild(l_player[currentPlayerIndex].cardsInHand[i])
							addChild(l_player[currentPlayerIndex].cardsInHand[i])
						}
						if (cardsCanBePlayed().length == 0)
						{
							trace('无牌可出！')
						}
						currentTask = '系统判定';
					}
					else
					{
						currentTask = '系统判定';
					}
				}
				else if (cardUsed[cardUsed.length - 1].type == Card.WILD)
				{
					trace('庄家翻牌为：变色牌。选择颜色。')
					var r_card:Card = new Card(Card.RED, Card.WILD);
					var g_card:Card = new Card(Card.GREEN, Card.WILD);
					var y_card:Card = new Card(Card.YELLOW, Card.WILD);
					var b_card:Card = new Card(Card.BLUE, Card.WILD);
					r_card.x = 0;
					r_card.y = 0;
					g_card.x = r_card.width;
					g_card.y = 0;
					y_card.x = 0;
					y_card.y = r_card.height;
					b_card.x = r_card.width;
					b_card.y = r_card.height;
					r_card.tx = 0;
					r_card.ty = 0;
					g_card.tx = r_card.width;
					g_card.ty = 0;
					y_card.tx = 0;
					y_card.ty = r_card.height;
					b_card.tx = r_card.width;
					b_card.ty = r_card.height;
					colorChooser.addChild(r_card);
					colorChooser.addChild(g_card);
					colorChooser.addChild(y_card);
					colorChooser.addChild(b_card);
					r_card.addEventListener(MouseEvent.MOUSE_UP, chooseColor)
					g_card.addEventListener(MouseEvent.MOUSE_UP, chooseColor)
					y_card.addEventListener(MouseEvent.MOUSE_UP, chooseColor)
					b_card.addEventListener(MouseEvent.MOUSE_UP, chooseColor)
					colorChooser.x = (stage.stageWidth - colorChooser.width) / 2
					colorChooser.y = (stage.stageHeight - colorChooser.height) / 2
					addChild(colorChooser)
					this.timer.reset()
					currentTask = '系统判定';
				}
				else if (cardUsed[cardUsed.length - 1].type == Card.WDF)
				{
					trace('庄家翻牌为：+4牌。重抽。')
					currentTask = 'bossChooseColor';
				}
				else
				{
					trace('庄家翻牌为：数字牌:', cardUsed[cardUsed.length - 1].color, cardUsed[cardUsed.length - 1].num)
					currentTask = '系统判定';
					this.timer.delay = 1500;
				}
				break;
			
			//核心循环
			case '系统判定': 
				if (isClockwise == 1)
				{
					currentPlayerIndex--;
				}
				else
				{
					currentPlayerIndex++;
				}
				if (currentPlayerIndex >= playerAmount)
				{
					currentPlayerIndex = 0;
				}
				else if (currentPlayerIndex <= -1)
				{
					currentPlayerIndex = playerAmount - 1;
				}
				trace('上一张牌为：', cardUsed[cardUsed.length - 1].color, cardUsed[cardUsed.length - 1].type, cardUsed[cardUsed.length - 1].num)
				//检测是否被跳过
				if (cardUsed[cardUsed.length - 1].type == Card.SKIP)
				{
					trace('上一张牌为：跳过牌。')
					if (cardNewlyPlayed)
					{
						trace('且为新出牌。')
						cardNewlyPlayed = false;
					}
					else
					{
						trace('且非新出牌。')
						if (currentPlayerIndex == 0)
						{
							currentTask = '出牌';
						}
						else
						{
							currentTask = '电脑出牌';
						}
					}
					this.timer.delay = 1500;
				}
				//检测是否系统抽牌
				else if (cardUsed[cardUsed.length - 1].type == Card.DT)
				{
					if (cardNewlyPlayed)
					{
						trace('且为新出牌。')
						if (cardUnused.length >= 2)
						{
							var tmp:Card = cardUnused.pop()
							removeChild(tmp)
							addChild(tmp)
							l_player[currentPlayerIndex].giveCard(tmp);
							var tmp:Card = cardUnused.pop()
							removeChild(tmp)
							addChild(tmp)
							l_player[currentPlayerIndex].giveCard(tmp);
							if (currentPlayerIndex == 0)
							{
								l_player[currentPlayerIndex].cardsInHand[l_player[currentPlayerIndex].cardsInHand.length - 2].isFront = true;
								l_player[currentPlayerIndex].cardsInHand[l_player[currentPlayerIndex].cardsInHand.length - 1].isFront = true;
								l_player[currentPlayerIndex].sortHand()
								for (var i:int = 0; i < l_player[currentPlayerIndex].cardsInHand.length; i++)
								{
									removeChild(l_player[currentPlayerIndex].cardsInHand[i])
									addChild(l_player[currentPlayerIndex].cardsInHand[i])
								}
							}
							cardNewlyPlayed = false;
						}
						else
						{
							trace('加牌！')
							currentTask = '加牌'
						}
					}
					else
					{
						trace('且非新出牌。')
						currentTask = '出牌'
					}
				}
				else if (cardUsed[cardUsed.length - 1].type == Card.WDF)
				{
					if (cardNewlyPlayed)
					{
						trace('且为新出牌。')
						if (cardUnused.length >= 4)
						{
							var tmp:Card = cardUnused.pop()
							removeChild(tmp)
							addChild(tmp)
							l_player[currentPlayerIndex].giveCard(tmp);
							var tmp:Card = cardUnused.pop()
							removeChild(tmp)
							addChild(tmp)
							l_player[currentPlayerIndex].giveCard(tmp);
							var tmp:Card = cardUnused.pop()
							removeChild(tmp)
							addChild(tmp)
							l_player[currentPlayerIndex].giveCard(tmp);
							var tmp:Card = cardUnused.pop()
							removeChild(tmp)
							addChild(tmp)
							l_player[currentPlayerIndex].giveCard(tmp);
							if (currentPlayerIndex == 0)
							{
								l_player[currentPlayerIndex].cardsInHand[l_player[currentPlayerIndex].cardsInHand.length - 4].isFront = true;
								l_player[currentPlayerIndex].cardsInHand[l_player[currentPlayerIndex].cardsInHand.length - 3].isFront = true;
								l_player[currentPlayerIndex].cardsInHand[l_player[currentPlayerIndex].cardsInHand.length - 2].isFront = true;
								l_player[currentPlayerIndex].cardsInHand[l_player[currentPlayerIndex].cardsInHand.length - 1].isFront = true;
								l_player[currentPlayerIndex].sortHand()
								for (var i:int = 0; i < l_player[currentPlayerIndex].cardsInHand.length; i++)
								{
									removeChild(l_player[currentPlayerIndex].cardsInHand[i])
									addChild(l_player[currentPlayerIndex].cardsInHand[i])
								}
							}
							cardNewlyPlayed = false;
						}
						else
						{
							trace('加牌！')
							currentTask = '加牌'
						}
					}
					else
					{
						trace('且非新出牌。')
						currentTask = '出牌';
					}
				}
				else
				{
					currentTask = '出牌';
				}
				break;
			case '出牌': 
				//检测是否贫穷抽牌
				if (cardsCanBePlayed().length == 0)
				{
					trace('玩家', currentPlayerIndex, '无牌可出！抽牌。')
					if (cardUnused.length >= 1)
					{
						var tmp:Card = cardUnused.pop()
						removeChild(tmp)
						addChild(tmp)
						l_player[currentPlayerIndex].giveCard(tmp);
						if (currentPlayerIndex == 0)
						{
							l_player[currentPlayerIndex].cardsInHand[l_player[currentPlayerIndex].cardsInHand.length - 1].isFront = true;
							l_player[currentPlayerIndex].sortHand()
							for (var i:int = 0; i < l_player[currentPlayerIndex].cardsInHand.length; i++)
							{
								removeChild(l_player[currentPlayerIndex].cardsInHand[i])
								addChild(l_player[currentPlayerIndex].cardsInHand[i])
							}
						}
						
					}
					else
					{
						trace('加牌！')
						currentTask = '加牌'
					}
				}
				else
				{
					if (currentPlayerIndex == 0)
					{
						currentTask = '玩家出牌';
						currentTask = '电脑出牌';
							//for (var i:int = 0; i < l_player[currentPlayerIndex].cardsInHand.length; i++)
							//{
							//l_player[currentPlayerIndex].cardsInHand[i].addEventListener(MouseEvent.MOUSE_UP, playCard)
							//}
							//this.timer.reset();
					}
					else
					{
						currentTask = '电脑出牌';
					}
				}
				break;
			case '玩家出牌': 
				currentTask = '生效';
				this.timer.delay = 1000;
				break;
			case '电脑出牌': 
				debug_ai();
				if (cardUsed[cardUsed.length - 1].type == Card.WILD || cardUsed[cardUsed.length - 1].type == Card.WDF)
				{
					var rdm:int = int(Math.random() * 4);
					if (rdm == 4)
					{
						rdm--
					}
					switch (rdm)
					{
					case 0: 
						cardUsed[cardUsed.length - 1].setSub(Card.RED)
						break;
					case 1: 
						cardUsed[cardUsed.length - 1].setSub(Card.GREEN)
						break;
					case 2: 
						cardUsed[cardUsed.length - 1].setSub(Card.YELLOW)
						break;
					case 3: 
						cardUsed[cardUsed.length - 1].setSub(Card.BLUE)
						break;
					}
				}
				currentTask = '电脑出牌的翻牌';
				this.timer.delay = 1000;
				break;
			case '电脑出牌的翻牌': 
				cardUsed[cardUsed.length - 1].isFront = true;
				currentTask = '生效';
				this.timer.delay = 1000;
				break;
			case '生效': 
				if (cardUsed[cardUsed.length - 1].type == Card.RVS)
				{
					isClockwise = -isClockwise
				}
				currentTask = '系统判定';
				if (l_player[currentPlayerIndex].cardsInHand.length < 1)
				{
					currentTask = '胜利';
				}
				cardNewlyPlayed = true;
				this.timer.delay = 1000;
				break;
			case '加牌': 
				var newUnusedCards:Array = new Array();
				for (var i:int = 0; cardUsed.length > 1; i++)
				{
					var tmp:Card = cardUsed.shift();
					tmp.isFront = false;
					tmp.tx = (stage.stageWidth - tmp.width) / 2;
					tmp.ty = (stage.stageHeight - tmp.height) / 2;
					tmp.seed = Math.random();
					newUnusedCards.push();
				}
				cardUnused = newUnusedCards.sortOn('seed');
				
				for (var i:int = 0; i < cardUnused.length; i++)
				{
					removeChild(cardUnused[i])
					addChild(cardUnused[i])
				}
				if (isClockwise == 1)
				{
					currentPlayerIndex++;
				}
				else
				{
					currentPlayerIndex--;
				}
				currentTask = '系统判定';
				this.timer.delay = 1000;
				break;
			case '胜利': 
				trace('玩家', currentPlayerIndex, '获胜！')
				bossIndex = currentPlayerIndex;
				for (var i:int = 0; i < playerAmount; i++)
				{
					while (l_player[i].cardsInHand.length > 0)
					{
						var tmp:Card = l_player[i].cardsInHand.pop()
						removeChild(tmp);
						tmp.isFront = true;
						addChild(tmp);
						var target:Point = getRamUsedCardP();
						tmp.tx = target.x;
						tmp.ty = target.y;
						cardUsed.push(tmp);
					}
				}
				currentTask = '全体明牌';
				this.timer.delay = 1000;
				break;
			case '全体明牌': 
				for (var i:int = 0; i < cardUsed.length; i++)
				{
					cardUsed.pop();
				}
				currentTask = 'messCards';
				this.timer.delay = 1000;
				break;
			case 'start': 
				if (isClockwise == 1)
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
		
		private function chooseColor(e:MouseEvent)
		{
			cardUsed[cardUsed.length - 1].setSub(e.target.color);
			colorChooser.removeChildren()
			removeChild(colorChooser)
			currentTask = '玩家出牌';
			this.timer.start();
		}
		
		private function debug_ai():void
		{
			var cardSeeds:Array = cardsCanBePlayed()
			if (cardSeeds.length > 0)
			{
				var tmp:Card = l_player[currentPlayerIndex].fetchCard(cardSeeds[0])
				removeChild(tmp)
				addChild(tmp)
				var target:Point = getRamUsedCardP()
				tmp.tx = target.x
				tmp.ty = target.y
				cardUsed.push(tmp)
			}
			else
			{
				currentTask = '抽牌';
				if (isClockwise == 1)
				{
					currentPlayerIndex++;
				}
				else
				{
					currentPlayerIndex--;
				}
				if (currentPlayerIndex >= playerAmount)
				{
					currentPlayerIndex = 0;
				}
				else if (currentPlayerIndex <= -1)
				{
					currentPlayerIndex = playerAmount - 1;
				}
			}
		}
		
		private function cardsCanBePlayed():Array
		{
			var cardsToPlay:Array = new Array();
			//for (var i:int = 0; i < cardUsed.length; i++)
			//{
			//trace('cardUsed: ', cardUsed[cardUsed.length - 1].color, cardUsed[cardUsed.length - 1].type, cardUsed[cardUsed.length - 1].num)
			//}
			for (var i:int = 0; i < l_player[currentPlayerIndex].cardsInHand.length; i++)
			{
				//trace('cardsInHand: ', l_player[currentPlayerIndex].cardsInHand[i].color, l_player[currentPlayerIndex].cardsInHand[i].type, l_player[currentPlayerIndex].cardsInHand[i].num);
				if (l_player[currentPlayerIndex].cardsInHand[i].type == Card.WILD)
				{
					cardsToPlay.push(l_player[currentPlayerIndex].cardsInHand[i].seed)
				}
				else if (l_player[currentPlayerIndex].cardsInHand[i].type == Card.WDF)
				{
					cardsToPlay.push(l_player[currentPlayerIndex].cardsInHand[i].seed)
				}
				else if (l_player[currentPlayerIndex].cardsInHand[i].color == cardUsed[cardUsed.length - 1].color)
				{
					cardsToPlay.push(l_player[currentPlayerIndex].cardsInHand[i].seed)
				}
				else if (l_player[currentPlayerIndex].cardsInHand[i].type == cardUsed[cardUsed.length - 1].type)
				{
					if (l_player[currentPlayerIndex].cardsInHand[i].type == Card.NUM)
					{
						if (l_player[currentPlayerIndex].cardsInHand[i].num == cardUsed[cardUsed.length - 1].num)
						{
							cardsToPlay.push(l_player[currentPlayerIndex].cardsInHand[i].seed)
						}
					}
					else
					{
						cardsToPlay.push(l_player[currentPlayerIndex].cardsInHand[i].seed)
					}
				}
			}
			return cardsToPlay;
		}
		
		private function playCard(e:MouseEvent):void
		{
			var found:Boolean = false;
			var list:Array = cardsCanBePlayed()
			for (var i:int = 0; i < list.length; i++)
			{
				if (e.target.seed == list[i])
				{
					found = true;
				}
			}
			if (found)
			{
				for (var i:int = 0; i < l_player[currentPlayerIndex].cardsInHand.length; i++)
				{
					l_player[currentPlayerIndex].cardsInHand[i].removeEventListener(MouseEvent.MOUSE_UP, playCard)
				}
				var tmp:Card = l_player[currentPlayerIndex].fetchCard(e.target.seed)
				removeChild(tmp)
				addChild(tmp)
				var target:Point = getRamUsedCardP()
				tmp.tx = target.x
				tmp.ty = target.y
				cardUsed.push(tmp)
				l_player[currentPlayerIndex].sortHand()
				if (cardUsed[cardUsed.length - 1].type == Card.WILD || cardUsed[cardUsed.length - 1].type == Card.WDF)
				{
					var r_card:Card = new Card(Card.RED, Card.WILD);
					var g_card:Card = new Card(Card.GREEN, Card.WILD);
					var y_card:Card = new Card(Card.YELLOW, Card.WILD);
					var b_card:Card = new Card(Card.BLUE, Card.WILD);
					r_card.x = 0;
					r_card.y = 0;
					g_card.x = r_card.width;
					g_card.y = 0;
					y_card.x = 0;
					y_card.y = r_card.height;
					b_card.x = r_card.width;
					b_card.y = r_card.height;
					r_card.tx = 0;
					r_card.ty = 0;
					g_card.tx = r_card.width;
					g_card.ty = 0;
					y_card.tx = 0;
					y_card.ty = r_card.height;
					b_card.tx = r_card.width;
					b_card.ty = r_card.height;
					colorChooser.addChild(r_card);
					colorChooser.addChild(g_card);
					colorChooser.addChild(y_card);
					colorChooser.addChild(b_card);
					r_card.addEventListener(MouseEvent.MOUSE_UP, chooseColor)
					g_card.addEventListener(MouseEvent.MOUSE_UP, chooseColor)
					y_card.addEventListener(MouseEvent.MOUSE_UP, chooseColor)
					b_card.addEventListener(MouseEvent.MOUSE_UP, chooseColor)
					colorChooser.x = (stage.stageWidth - colorChooser.width) / 2
					colorChooser.y = (stage.stageHeight - colorChooser.height) / 2
					addChild(colorChooser)
				}
				else
				{
					this.timer.start()
				}
			}
		}
		
		private function getRamUsedCardP():Point
		{
			var isCertificated = false;
			var newPoint:Point = new Point;
			while (!isCertificated)
			{
				var angle:Number = Math.random() * 2 * Math.PI;
				newPoint.x = stage.stageWidth / 2 + Math.random() * stage.stageWidth / 3.5 * Math.sin(angle) - allCards[0].width / 2
				newPoint.y = stage.stageHeight / 2 + Math.random() * stage.stageHeight / 4.5 * Math.cos(angle) - allCards[0].height / 2
				if (!(stage.stageWidth / 2 - allCards[0].width / 2 * 3 < newPoint.x && newPoint.x < stage.stageWidth / 2 + allCards[0].width / 2 && stage.stageHeight / 2 - allCards[0].height / 2 * 3 < newPoint.y && newPoint.y < stage.stageHeight / 2 + allCards[0].height / 2))
				{
					isCertificated = true;
				}
			}
			return newPoint;
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