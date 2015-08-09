package ben.flash.greatreflector
{
	import ben.flash.greatreflector.command.ICommand;
	import ben.flash.greatreflector.command.CommandFactory;
	import ben.flash.greatreflector.command.SelectCommand;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Ben
	 */
	public class GreatReflector extends Sprite 
	{
		// select button
		private var _selectBtn:SimpleButton;
		// information text of current command handler
		private var _infoText:TextField;
		// current command handler
		private var _cmd:ICommand;
		// current command handler type
		private var _cmdType:int;
		// previous mouse x position
		private var _prevMouseX:int;
		// previous mouse y position
		private var _prevMouseY:int;
		// check if it's dragging now
		private var _dragging:Boolean;
		
		public function GreatReflector() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			trace("[GreatReflector]: initialized");
			// set default command handler
			_cmdType = CommandFactory.TYPE_DEFAULT;
			_cmd = CommandFactory.getCommand(_cmdType);
			
			// load image for select button
			var request:URLRequest = new URLRequest("img/youtube.png");
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
			loader.load(request);
			
			// create and add information text
			_infoText = new TextField();
			_infoText.x = 40;
			_infoText.y = 5;
			_infoText.mouseEnabled = false;
			this.addChild(_infoText);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		/**
		 * handler of load complete event
		 * @param	event
		 */
		private function loadCompleteHandler(event:Event):void
		{
			var loaderInfo:LoaderInfo = event.currentTarget as LoaderInfo;
			var loader:Loader = loaderInfo.loader;
			// attain the image
			var img:Bitmap = loader.content as Bitmap;
			// create and add the select button
			_selectBtn = new SimpleButton(img, img, img, img);
			_selectBtn.addEventListener(MouseEvent.CLICK, selectBtnClickHandler);
			this.addChild(_selectBtn);
			loader.unload();
		}
		
		/**
		 * handler of mouse_click event for select button
		 * @param	event
		 */
		private function selectBtnClickHandler(event:MouseEvent):void
		{
			// update command type
			if (_cmdType == CommandFactory.TYPE_SELECT)
			{
				_cmdType = CommandFactory.TYPE_DEFAULT;
			}
			else
			{
				_cmdType = CommandFactory.TYPE_SELECT;
			}
			// clear previous command handler
			_cmd.dispose();
			// update command handler
			_cmd = CommandFactory.getCommand(_cmdType);
		}
		
		/**
		 * handler of mouse_down event
		 * @param	event
		 */
		private function mouseDownHandler(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_cmd.onMouseDown(event);
			
			// set previous mouse position
			_prevMouseX = event.stageX;
			_prevMouseY = event.stageY;
			// it's not dragging at first
			_dragging = false;
		}
		
		/**
		 * handler of mouse_up event
		 * @param	event
		 */
		private function mouseUpHandler(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		
		/**
		 * handler of mouse_move event
		 * @param	event
		 */
		private function mouseMoveHandler(event:MouseEvent):void
		{
			// check if it's a move operation
			var offsetX:int = event.stageX - _prevMouseX;
			var offsetY:int = event.stageY - _prevMouseY;
			if (!_dragging && Math.abs(offsetX) <= 5 && Math.abs(offsetY) <= 5)
			{
				return;
			}
			// it's dragging now
			_dragging = true;
			_cmd.onMouseMove(event, offsetX, offsetY);
			// update previous mouse position
			_prevMouseX = event.stageX;
			_prevMouseY = event.stageY;
		}
		
		/**
		 * handler of key_down event
		 * @param	event
		 */
		private function keyDownHandler(event:KeyboardEvent):void
		{
			_cmd.onKeyDown(event);
		}
		
		/**
		 * handler of enter_frame event
		 * @param	event
		 */
		private function enterFrameHandler(event:Event):void
		{
			var info:String = _cmd.info();
			if (info != null)
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