package ben.flash.greatreflector 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Ben
	 */
	public class TestGreatReflector extends Sprite 
	{
		
		public function TestGreatReflector() 
		{
			super();
			
			var obj1:Sprite = new Sprite();
			obj1.graphics.beginFill(0xFF0000);
			obj1.graphics.drawRect(20, 20, 50, 50);
			obj1.graphics.endFill();
			obj1.name = "longlonglongname";
			this.addChild(obj1);
			
			var obj2:Sprite = new Sprite();
			obj2.graphics.beginFill(0x00FF00);
			obj2.graphics.drawRect(30, 30, 50, 50);
			obj2.graphics.endFill();
			obj1.addChild(obj2);
			
			var obj3:Sprite = new Sprite();
			obj3.graphics.beginFill(0x0000FF);
			obj3.graphics.drawRect(40, 40, 50, 50);
			obj3.graphics.endFill();
			obj1.addChildAt(obj3, 0);
			
			obj1.addEventListener(MouseEvent.CLICK, obj1MouseClickHandler);
			
			stage.addChild(new GreatReflector());
		}
		
		private function obj1MouseClickHandler(event:MouseEvent):void
		{
			trace("aaa");
		}
	}

}