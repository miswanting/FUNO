package
{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.net.URLRequest;
	import Intro;
	import Menu;
	
	/**
	 * ...
	 * @author 何雨航
	 */
	public class Main extends Sprite
	{
		
		public function Main()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// 程序入口
			trace("程序启动");
			trace('窗口尺寸：' + stage.stageWidth.toString() + 'x' + stage.stageHeight.toString())
			showIntro();
			//addEventListener(Event.ENTER_FRAME, core);
		}
		
		private function showIntro():void
		{
			var intro:Intro = new Intro();
			stage.addChild(intro)
			intro.addEventListener(Event.REMOVED_FROM_STAGE, showMenu)
			intro.show();
		}
		
		private function showMenu(e:Event):void
		{
			var menu:Menu = new Menu();
			stage.addChild(menu)
			menu.show();
		}
		
		private function core(e:Event):void
		{
			trace(stage);
		}
	
	}

}