package ben.flash.greatreflector
{
	import ben.flash.greatreflector.command.CommandFactory;
	import ben.flash.greatreflector.command.ICommand;
	import ben.flash.greatreflector.effect.Filters;
	import ben.flash.greatreflector.ui.InfoPanel;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Ben
	 */
	public class GreatReflector extends Sprite
	{
		// select button
		private var _selectBtn:SimpleButton;
		// information panel
		private var _infoPanel:InfoPanel;
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
		
		[Embed(source="img/selectBtn.png")]    
        private var select:Class; 
		
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
			
			// attain the image
			var img:* = new select();
			// create and add the select button
			_selectBtn = new SimpleButton(img, img, img, img);
			_selectBtn.addEventListener(MouseEvent.MOUSE_DOWN, selectBtnDownHandler);
			_selectBtn.addEventListener(MouseEvent.CLICK, selectBtnClickHandler);
			this.addChild(_selectBtn);
			
			// create and add information panel
			_infoPanel = new InfoPanel();
			_infoPanel.x = 40;
			_infoPanel.y = 0;
			this.addChild(_infoPanel);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		/**
		 * use to block the behavior of mouseDownHandler
		 * @param	event
		 */
		private function selectBtnDownHandler(event:MouseEvent):void
		{
			event.stopPropagation();
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
				_selectBtn.filters = null;
			}
			else
			{
				_cmdType = CommandFactory.TYPE_SELECT;
				_selectBtn.filters = [Filters.lightFilter1];
			}
			
			// whether block original mouse event listener
			setStageMouseEnabled(_cmdType == CommandFactory.TYPE_DEFAULT);
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
			_infoPanel.setInfo(_cmd.info());
		}
		
		/**
		 * set mouseEnabled and mouseChildren value of 
		 * the display objects in the stage except GreatReflector,
		 * use this to avoid triggering mouse event listener
		 * of these display objects
		 * @param	enabled
		 */
		private function setStageMouseEnabled(enabled:Boolean):void
		{
			for (var i:int = 0; i < stage.numChildren; i++)
			{
				var child:DisplayObject = stage.getChildAt(i);
				if (child == this)
				{
					continue;
				}
				if (child is InteractiveObject)
				{
					(child as InteractiveObject).mouseEnabled = enabled;
				}
				if (child is DisplayObjectContainer)
				{
					(child as DisplayObjectContainer).mouseChildren = enabled;
				}
			}
		}
	}
	
}