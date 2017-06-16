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
			//this.stage.removeChild(this);
			var t:TextField = new TextField;
			t.text = "开始游戏";
			t.border = true;
			t.autoSize = TextFieldAutoSize.LEFT;
			var btn_start:SimpleButton = new SimpleButton;
			btn_start.upState = t;
			//btn.width = t.width / 2
			//btn.height = t.height
			addEventListener(MouseEvent.MOUSE_UP, startGame)
			btn_start.x = (stage.stageWidth - btn_start.width) / 2
			btn_start.y = (stage.stageHeight - btn_start.height) / 2
			trace('窗口尺寸：' + stage.stageWidth.toString() + 'x' + stage.stageHeight.toString())
			menu.addChild(btn_start);
		}
		
		public function startGame(e:Event):void
		{
			removeChild(menu)
			var game:Game = new Game();
			stage.addChild(game)
			game.start()
		}
	
	}

}