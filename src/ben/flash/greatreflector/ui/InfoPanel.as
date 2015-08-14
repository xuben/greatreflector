package ben.flash.greatreflector.ui 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Ben
	 */
	public class InfoPanel extends Sprite
	{
		// information text of current command handler
		private var _infoText:TextField;
		
		/**
		 * constructor
		 */
		public function InfoPanel() 
		{
			// create and add information text
			_infoText = new TextField();
			_infoText.multiline = true;
			this.addChild(_infoText);
			
			// set background
			this.graphics.beginFill(0xFFFFFF, 0.8);
			this.graphics.drawRect(-5, 0, 110, 40);
			this.graphics.endFill();
			
			this.mouseChildren = this.mouseEnabled = false;
		}
		
		/**
		 * update information text
		 * @param	info
		 */
		public function setInfo(info:String):void
		{
			if (info)
			{
				_infoText.text = info;
			}
			else
			{
				_infoText.text = "";
			}
		}
	}

}