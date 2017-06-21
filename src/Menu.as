package
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize
	import flash.events.Event;
	import Game;
	
	/**
	 * ...
	 * @author 何雨航
	 */
	public class Menu extends Sprite
	{
		public var menu:Sprite = new Sprite;
		
		public function Menu()
		{
			addChild(menu)
		}
		
		public function show():void
		{
			trace("显示标题画面");
			var t:TextField = new TextField;
			t.text = "单人游戏";
			t.border = true;
			t.autoSize = TextFieldAutoSize.LEFT;
			var btn_start:SimpleButton = new SimpleButton;
			btn_start.overState = t;
			btn_start.downState = t;
			btn_start.upState = t;
			btn_start.hitTestState = t;
			btn_start.x = (stage.stageWidth - btn_start.width) / 2
			btn_start.y = (stage.stageHeight - btn_start.height) / 2
			menu.addChild(btn_start);
			
			var t:TextField = new TextField;
			t.text = "多人游戏";
			t.border = true;
			t.autoSize = TextFieldAutoSize.LEFT;
			var btn_start:SimpleButton = new SimpleButton;
			btn_start.overState = t;
			btn_start.downState = t;
			btn_start.upState = t;
			btn_start.hitTestState = t;
			btn_start.x = (stage.stageWidth - btn_start.width) / 2
			btn_start.y = (stage.stageHeight - btn_start.height) / 2 + stage.stageHeight / 12
			menu.addChild(btn_start);
			addEventListener(MouseEvent.MOUSE_UP, startSingleGame)
			
			var t:TextField = new TextField;
			t.text = "游戏设置";
			t.border = true;
			t.autoSize = TextFieldAutoSize.LEFT;
			var btn_start:SimpleButton = new SimpleButton;
			btn_start.overState = t;
			btn_start.downState = t;
			btn_start.upState = t;
			btn_start.hitTestState = t;
			btn_start.x = (stage.stageWidth - btn_start.width) / 2
			btn_start.y = (stage.stageHeight - btn_start.height) / 2 + stage.stageHeight / 6
			menu.addChild(btn_start);
			addEventListener(MouseEvent.MOUSE_UP, startSingleGame)
			
			var t:TextField = new TextField;
			t.text = "退出游戏";
			t.border = true;
			t.autoSize = TextFieldAutoSize.LEFT;
			var btn_start:SimpleButton = new SimpleButton;
			btn_start.overState = t;
			btn_start.downState = t;
			btn_start.upState = t;
			btn_start.hitTestState = t;
			btn_start.x = (stage.stageWidth - btn_start.width) / 2
			btn_start.y = (stage.stageHeight - btn_start.height) / 2 + stage.stageHeight / 4
			menu.addChild(btn_start);
			addEventListener(MouseEvent.MOUSE_UP, startSingleGame)
		}
		
		public function startSingleGame(e:Event):void
		{
			removeChild(menu)
			var game:Game = new Game();
			stage.addChild(game)
			game.start()
		}
	
	}

}