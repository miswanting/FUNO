package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author 何雨航
	 */
	public class Intro extends Sprite
	{
		
		public function Intro()
		{
		}
		
		public function show():void
		{
			trace("显示开场动画");
			this.stage.removeChild(this);
		}
	}

}